

## Messages

Message
  |
  | - Header
  |     |
  |     | - ID
  |     | - Size (Bytes, including the header)
  |
  | - Body (0 or more bytes)


The Header is always send first and has a fixed size. The ID can be a int, but is better use a enum.


## Architecture

Client#1 --------------> Connection             Connection <-------------- Server -
  Queue <-               Queue _                   _ Queue                         |
          \                     \ out         out /                     ---> Queue |
           \                     --->  Socket <---                     /   ^       |
            \                    in    /    \    in                   /   /        |
             --------------------------      ------------------------     \        |
                                                                          /        |
Client#2 --------------> Connection             Connection <------------ / --------
  Queue <-               Queue _                   _ Queue              /
          \                     \ out         out /                    /
           \                     --->  Socket <---                    /
            \                    in    /    \    in                  /
             --------------------------      ------------------------

### Components

  - Queue
  - Client
  - Connection
  - Server