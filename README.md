# VLC Playlist Rememberer
An extension that save the last played item of a playlist to continue later on.

Setup
---
Copy ``VPR.lua`` file to 
- **Linux:** ``~/.local/share/vlc/lua/extensions/`` and ``~/.local/share/vlc/lua/extensions/playlist/``

- **Windows:** ``C:\Program Files\VideoLAN\VLC\lua\extensions\ `` and ``C:\Program Files\VideoLAN\VLC\lua\playlist\ ``

**_Create directories if do not exist_**
    
Create a resumable playlist
---
1. Create a text file with the following format: (only for the first time)
    
    - **First line:** ``VPR84296c0939f946089f45c97b9981afde``
    
    - **Second line:** The last played file URI like: ``file:///tmp/Videos/Video1.mkv``. Empty line to start from beginning
    
    - **Other lines:** Each line should be a file URI like: ``file:///tmp/Videos/Video1.mkv``. Each line is a playlist item
 
2. Then open the created file with VLC

3. Enable ``VPR`` extension in VLC fom View --> VPR (this should be enabled each time VLC opens)

- **__Please don't place the file anywhere that VLC doesn't have permission to read or write__**

- **__File or URL can be used__**

- **__Look at the ``PlaylistTextFileExample.txt``__**

How this works
---
If a text file with the first line of ``VPR84296c0939f946089f45c97b9981afde`` opened in VLC this extension will create a playlist with URI from line 3 to the last (each line one item).
And put the address of the playlist text file with an indentifier string to each item's description (to be able to update last played item).

Every time a new item starts playing, it's description will be checked. If the indetifier and a file address exist then the second line of the file will change to the URI of the current playing item.