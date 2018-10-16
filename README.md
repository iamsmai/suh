# suh

SUH is a cool Flutter mobile app where you can send messages to your friends! 
I mean your fam!

## Suh App Schema

### User
**id**
The globally unique ID is a hash of the user's phone number. We will get this from the authentication system in Firebase.

#### name
The publicly visible name of this user. There are no special requirements placed on this field.

#### blocklist
A map of sender IDs to sender names that will be ignored if they attempt to send the user a message.

#### received
A map of sender IDs to the latest Message received from each.

In the example below, this user has received one messsage. The message was from "hannah".

```
{
    "hannah": {
        "color" "ababab"   // hex value
        "time" 23423,      // milliseconds since epoch
        "char" "T"         // one-char limit
    }
}
```

#### sent
A map of recipient IDs of Messages sent to each of those users.

In the example below, this user has sent one message. The message was sent to "stella".

```
{
    "stella": {
        "color" "eeeeee"   // hex value
        "time" 23423,      // milliseconds since epoch
        "char" "E"         // one-char limit
    }
}
```

### Message

#### color
The hex value of the color for this message.

#### time
The client timestamp when the message was sent.

#### char
The character sent along with the message.