# PSmailingBot

automation of repetitive emails. Work In Progress

End goal of the program  
>	-split into a launcher and build. 
>	-launcher will schedule itself to run, using windows task scheduler, on conditions given by the user. 
>	-launcher will cross attempt to check the local version against the github repository and install a newer version if available. Then execute the actual build.
>	-build will interact with the user through a cli, allowing the user to set a email account of their choice and  mailing groups with unique things to send to.
>	-mail will be sent at scheduled time regardless of user absence

# mingB_sender

my first try at a mailing bot. incomplete but shows thats its doable

what it can do  
>	-save and use a given email account. note: stores account and password together as a txt file.
>	-by storing everything as readable text, the user is able to directly edit the files to contain what they want.
>	-attachment randomization with weight scales. attachments include html
