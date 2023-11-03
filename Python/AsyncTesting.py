# Just me testing with the asyncio module, trying to wrap my head around it by making small programs, basically.

import asyncio, time
from aioconsole import ainput

async def say_hi(timeTask):
    name = await ainput("What's your name?: ")
    match timeLevel:
        case 0:
            print(f"Hi {name}!")
        case 1:
            print(f"Hello, {name}! That uh, took a bit longer than expected.")
    timeTask.cancel()
    
async def time_hi():
    global timeLevel
    try:
        timeLevel = 0
        await asyncio.sleep(3)
        timeLevel = 1
    except asyncio.CancelledError:
        pass

async def main():
    try:
        async with asyncio.timeout(5):
            async with asyncio.TaskGroup() as tg:
                timeTask = tg.create_task(
                    time_hi())
                tg.create_task(
                    say_hi(timeTask))
                
    except asyncio.TimeoutError:
        print("\n\nWhat, you forgot your name or something?")

if __name__ == "__main__":
    s = time.perf_counter()
    asyncio.run(main())
    elapsed = time.perf_counter() - s
    print(f"Program executed in {elapsed:0.2f} seconds.")