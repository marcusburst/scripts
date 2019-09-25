## Sets an Out of Office for a User and uses HTML formatting ##

$reply = "<html><head></head><body><p>Hi and thank you for your email.</br></br>
I am out of the office with no access to emails returning on the 23rd September.</br></br>
In my absence, please contact This Person for any scheduling requests and That Person for any other queries.</br></br>
Best wishes,</br>
Employee A</p></body></html>"

Set-MailboxAutoReplyConfiguration -Identity username -AutoReplyState Enabled -InternalMessage $reply -ExternalMessage $reply


