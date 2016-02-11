-- config
property channel : "#general"
property username : "Thuongvu"
property webhook : "https://hooks.slack.com/services/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"

-- constants
property openSpotifyLink : "https://open.spotify.com/track/"

on getCurrentlyPlayingTrack()
	tell application "Spotify"
		
		set currentArtist to artist of current track as string
		set currentId to id of current track as string
		set currentTrack to name of current track as string
		set currentAlbum to album of current track as string
		set currentUrl to spotify url of current track as string
		
		set trackMeta to {idKey:{key:"id", value:currentId}, artistKey:{key:"artist", value:currentArtist}, trackKey:{key:"track", value:currentTrack}, albumKey:{key:"album", value:currentAlbum}, urlKey:{key:"url", value:currentUrl}}
		
		return trackMeta
	end tell
end getCurrentlyPlayingTrack

on generateMessage(trackMeta, musicServiceUrl)
	set artist to get value of artistKey of trackMeta
	set track to get value of trackKey of trackMeta
	set album to get value of albumKey of trackMeta
	set currentUrl to get value of urlKey of trackMeta
	
	set currentUrlString to ((characters 15 thru -1 of currentUrl) as string)
	set generatedUrl to musicServiceUrl & currentUrlString
	set artistTrack to artist & " - " & track
	set artistTrackLink to "<" & generatedUrl & " | " & artistTrack & ">."
	set message to "Currently listening to " & artistTrackLink & "."
	
	return message
end generateMessage

on sendMessage(message)
	do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"" & channel & "\", \"username\": \"" & username & "\", \"text\": \"" & message & "\"}' " & webhook
end sendMessage



set trackMetaData to getCurrentlyPlayingTrack()
set message to generateMessage(trackMetaData, openSpotifyLink)
sendMessage(message)
