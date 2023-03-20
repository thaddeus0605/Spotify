//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by Thaddeus Dronski on 3/11/23.
//

import Foundation

struct FeaturePlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
//{

//                        {
//                collaborative = 0;
//                description = "A perfect little pop party. ";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DWXti3N4Wp5xy";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DWXti3N4Wp5xy";
//                id = 37i9dQZF1DWXti3N4Wp5xy;
//                images =                 (
//                                        {
//                        height = "<null>";
//                        url = "https://i.scdn.co/image/ab67706f000000030326a92ce25b60530fe4dfbd";
//                        width = "<null>";
//                    }
//                );
//                name = "Pop Party";
//                owner =                 {
//                    "display_name" = Spotify;
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/spotify";
//                    };
//                    href = "https://api.spotify.com/v1/users/spotify";
//                    id = spotify;
//                    type = user;
//                    uri = "spotify:user:spotify";
//                };
//                "primary_color" = "<null>";
//                public = "<null>";
//                "snapshot_id" = MTY3NjI2MDE3MSwwMDAwMDAwMGUwNWJiZjZlNjQxYTRiMDEwOWMwYzhiYmY1MDYyOThj;
//                tracks =                 {
//                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DWXti3N4Wp5xy/tracks";
//                    total = 150;
//                };
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DWXti3N4Wp5xy";
//            },
//                        {
//                collaborative = 0;
//                description = "The best indie dance tracks of the moment. Cover: The Blaze";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DX8CopunbDxgW";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX8CopunbDxgW";
//                id = 37i9dQZF1DX8CopunbDxgW;
//                images =                 (
//                                        {
//                        height = "<null>";
//                        url = "https://i.scdn.co/image/ab67706f000000032c439b6578f8a5acfaf32ffe";
//                        width = "<null>";
//                    }
//                );
//                name = metropolis;
//                owner =                 {
//                    "display_name" = Spotify;
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/spotify";
//                    };
//                    href = "https://api.spotify.com/v1/users/spotify";
//                    id = spotify;
//                    type = user;
//                    uri = "spotify:user:spotify";
//                };
//                "primary_color" = "<null>";
//                public = "<null>";
//                "snapshot_id" = MTY3ODQ2MjA5MiwwMDAwMDAwMDU4OWE4NTU5Y2RhZWNlMGZmNzlhYWRjNDQ5NWU2MGU1;
//                tracks =                 {
//                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX8CopunbDxgW/tracks";
//                    total = 100;
//                };
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DX8CopunbDxgW";
//            }
//
//}
