#Cliente MCP: arranca server.py como subproceso y le habla por stdio
import asyncio
import json
import sys
from contextlib import AsyncExitStack
from typing import Any

from mcp import ClientSession, StdioServerParameters, types
from mcp.client.stdio import stdio_client
from pydantic import AnyUrl


class MCPClient:
    def __init__(self, command: str, args: list[str]):
        self._command = command
        self._args = args
        self._session: ClientSession | None = None
        self._exit_stack = AsyncExitStack()

    async def connect(self):
        server_params = StdioServerParameters(command=self._command, args=self._args)
        read, write = await self._exit_stack.enter_async_context(stdio_client(server_params))
        self._session = await self._exit_stack.enter_async_context(ClientSession(read, write))
        await self._session.initialize()

    def session(self) -> ClientSession:
        if self._session is None:
            raise ConnectionError("Client session not initialized. Call connect() first.")
        return self._session

    #Lista las herramientas que expone el servidor
    async def list_tools(self) -> list[types.Tool]:
        result = await self.session().list_tools()
        return result.tools

    #Ejecuta una herramienta del servidor
    async def call_tool(
        self, tool_name: str, tool_input: dict
    ) -> types.CallToolResult | None:
        return await self.session().call_tool(tool_name, tool_input)

    #Lectura de recursos: pide el recurso al servidor y lo procesa según su tipo MIME
    async def read_resource(self, uri: str) -> Any:
        result = await self.session().read_resource(AnyUrl(uri))
        resource = result.contents[0]

        if isinstance(resource, types.TextResourceContents):
            if resource.mimeType == "application/json":
                return json.loads(resource.text)
            return resource.text

        return resource.blob  # recurso binario (base64)

    #Lista los prompts que expone el servidor
    async def list_prompts(self) -> list[types.Prompt]:
        result = await self.session().list_prompts()
        return result.prompts

    #Obtiene un prompt del servidor con sus argumentos ya interpolados
    async def get_prompt(self, prompt_name, args: dict[str, str]):
        result = await self.session().get_prompt(prompt_name, args)
        return result.messages

    async def cleanup(self):
        await self._exit_stack.aclose()
        self._session = None

    async def __aenter__(self):
        await self.connect()
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await self.cleanup()


#Prueba: conecta con server.py, lista herramientas y llama una
async def main():
    async with MCPClient(command=sys.executable, args=["server.py"]) as client:
        tools = await client.list_tools()
        print("Herramientas:", [t.name for t in tools])

        result = await client.call_tool("read_doc_contents", {"doc_id": "report.pdf"})
        if result and isinstance(result.content[0], types.TextContent):
            print("Resultado:", result.content[0].text)

        print("Documentos:", await client.read_resource("docs://documents"))
        print("plan.md:", await client.read_resource("docs://documents/plan.md"))

        prompts = await client.list_prompts()
        print("Prompts:", [p.name for p in prompts])

        messages = await client.get_prompt("format", {"doc_id": "plan.md"})
        print("Prompt format:", messages)


if __name__ == "__main__":
    asyncio.run(main())
