package main
import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"
)
func main() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, syscall.SIGTERM)
	go func(){
		<-c
		os.Exit(1)
	}()

	for {
		fmt.Print(`.`)
		time.Sleep(1 * time.Second)
	}
}
