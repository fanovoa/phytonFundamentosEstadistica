#Aplicación principal: chat con Claude que usa las herramientas del servidor MCP
import asyncio
import os
import sys

from anthropic import AsyncAnthropic
from anthropic.types.beta import BetaToolParam
from dotenv import load_dotenv
from mcp import types

from mcp_client import MCPClient

load_dotenv()  # lee ANTHROPIC_API_KEY desde el archivo .env

MODEL = "claude-opus-5-5"


#Convierte las herramientas MCP al formato que entiende Claude
def to_claude_tools(mcp_tools) -> list[BetaToolParam]:
    return [
        {"name": t.name, "description": t.description or "", "input_schema": t.inputSchema}
        for t in mcp_tools
    ]


#Ejecuta en el servidor MCP cada herramienta que Claude pidió
async def run_tools(client: MCPClient, content) -> list[dict]:
    results = []
    for block in content:
        if block.type != "tool_use":
            continue
        print(f"  [herramienta] {block.name} {block.input}")
        result = await client.call_tool(block.name, block.input)
        if result is None:
            results.append({"type": "tool_result", "tool_use_id": block.id,
                            "content": "Tool returned no result", "is_error": True})
            continue
        text = "\n".join(c.text for c in result.content if isinstance(c, types.TextContent))
        results.append({
            "type": "tool_result",
            "tool_use_id": block.id,
            "content": text,
            "is_error": result.isError,
        })
    return results


#Una pregunta: llama a Claude hasta que deje de pedir herramientas
async def ask(claude: AsyncAnthropic, client: MCPClient, tools: list[BetaToolParam], messages: list):
    while True:
        response = await claude.beta.messages.create(
            model=MODEL,
            max_tokens=16000,
            tools=tools,
            messages=messages,
            betas=["server-side-fallback-2026-07-01"],
            fallbacks="default",
        )
        messages.append({"role": "assistant", "content": response.content})

        if response.stop_reason == "refusal":
            return "(Claude no respondió esta pregunta)"
        if response.stop_reason != "tool_use":
            return "".join(b.text for b in response.content if b.type == "text")

        messages.append({"role": "user", "content": await run_tools(client, response.content)})


async def main():
    if not os.environ.get("ANTHROPIC_API_KEY"):
        sys.exit("Falta ANTHROPIC_API_KEY: pégala en el archivo .env de esta carpeta.")
    claude = AsyncAnthropic()
    async with MCPClient(command=sys.executable, args=["server.py"]) as client:
        tools = to_claude_tools(await client.list_tools())
        print("Herramientas MCP:", [t["name"] for t in tools])
        print("Escribe tu pregunta (o 'salir').\n")

        messages = []  # historial: Claude recuerda la conversación
        while True:
            question = input("> ").strip()
            if question.lower() in ("salir", "exit", "quit"):
                break
            if not question:
                continue
            messages.append({"role": "user", "content": question})
            print("\n" + await ask(claude, client, tools, messages) + "\n")


if __name__ == "__main__":
    asyncio.run(main())
