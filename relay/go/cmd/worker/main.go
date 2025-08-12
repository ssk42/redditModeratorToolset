package main

import (
    "log"
    "time"
)

func main() {
    log.Println("relay worker starting (noop loop for now)")
    for {
        // TODO: polling & push logic per Tasks.md
        time.Sleep(30 * time.Second)
    }
}

