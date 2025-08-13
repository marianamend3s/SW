//
//  MockJSON.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import Foundation

enum MockJSON {
    
    // MARK: - Categories
    
    static let mockCategories: String = """
    
    {
        "films": "https://swapi.info/api/films",
        "people": "https://swapi.info/api/people",
        "planets": "https://swapi.info/api/planets",
        "species": "https://swapi.info/api/species",
        "vehicles": "https://swapi.info/api/vehicles",
        "starships": "https://swapi.info/api/starships"
    }
    """
    
    // MARK: - Films
    
    static let mockFilms: String = #"""
    [
        {
            "title": "A New Hope",
            "episode_id": 4,
            "opening_crawl": "It is a period of civil war.\r\nRebel spaceships, striking\r\nfrom a hidden base, have won\r\ntheir first victory against\r\nthe evil Galactic Empire.\r\n\r\nDuring the battle, Rebel\r\nspies managed to steal secret\r\nplans to the Empire's\r\nultimate weapon, the DEATH\r\nSTAR, an armored space\r\nstation with enough power\r\nto destroy an entire planet.\r\n\r\nPursued by the Empire's\r\nsinister agents, Princess\r\nLeia races home aboard her\r\nstarship, custodian of the\r\nstolen plans that can save her\r\npeople and restore\r\nfreedom to the galaxy....",
            "director": "George Lucas",
            "producer": "Gary Kurtz, Rick McCallum",
            "release_date": "1977-05-25",
            "characters": [
                "https://swapi.info/api/people/1",
                "https://swapi.info/api/people/2",
                "https://swapi.info/api/people/3",
                "https://swapi.info/api/people/4",
                "https://swapi.info/api/people/5",
                "https://swapi.info/api/people/6",
                "https://swapi.info/api/people/7",
                "https://swapi.info/api/people/8",
                "https://swapi.info/api/people/9",
                "https://swapi.info/api/people/10",
                "https://swapi.info/api/people/12",
                "https://swapi.info/api/people/13",
                "https://swapi.info/api/people/14",
                "https://swapi.info/api/people/15",
                "https://swapi.info/api/people/16",
                "https://swapi.info/api/people/18",
                "https://swapi.info/api/people/19",
                "https://swapi.info/api/people/81"
            ],
            "planets": [
                "https://swapi.info/api/planets/1",
                "https://swapi.info/api/planets/2",
                "https://swapi.info/api/planets/3"
            ],
            "starships": [
                "https://swapi.info/api/starships/2",
                "https://swapi.info/api/starships/3",
                "https://swapi.info/api/starships/5",
                "https://swapi.info/api/starships/9",
                "https://swapi.info/api/starships/10",
                "https://swapi.info/api/starships/11",
                "https://swapi.info/api/starships/12",
                "https://swapi.info/api/starships/13"
            ],
            "vehicles": [
                "https://swapi.info/api/vehicles/4",
                "https://swapi.info/api/vehicles/6",
                "https://swapi.info/api/vehicles/7",
                "https://swapi.info/api/vehicles/8"
            ],
            "species": [
                "https://swapi.info/api/species/1",
                "https://swapi.info/api/species/2",
                "https://swapi.info/api/species/3",
                "https://swapi.info/api/species/4",
                "https://swapi.info/api/species/5"
            ]
        },
        {
            "title": "The Empire Strikes Back",
            "episode_id": 5,
            "opening_crawl": "It is a dark time for the\r\nRebellion. Although the Death\r\nStar has been destroyed,\r\nImperial troops have driven the\r\nRebel forces from their hidden\r\nbase and pursued them across\r\nthe galaxy.\r\n\r\nEvading the dreaded Imperial\r\nStarfleet, a group of freedom\r\nfighters led by Luke Skywalker\r\nhas established a new secret\r\nbase on the remote ice world\r\nof Hoth.\r\n\r\nThe evil lord Darth Vader,\r\nobsessed with finding young\r\nSkywalker, has dispatched\r\nthousands of remote probes into\r\nthe far reaches of space....",
            "director": "Irvin Kershner",
            "producer": "Gary Kurtz, Rick McCallum",
            "release_date": "1980-05-17",
            "characters": [
                "https://swapi.info/api/people/1",
                "https://swapi.info/api/people/2",
                "https://swapi.info/api/people/3",
                "https://swapi.info/api/people/4",
                "https://swapi.info/api/people/5",
                "https://swapi.info/api/people/10",
                "https://swapi.info/api/people/13",
                "https://swapi.info/api/people/14",
                "https://swapi.info/api/people/18",
                "https://swapi.info/api/people/20",
                "https://swapi.info/api/people/21",
                "https://swapi.info/api/people/22",
                "https://swapi.info/api/people/23",
                "https://swapi.info/api/people/24",
                "https://swapi.info/api/people/25",
                "https://swapi.info/api/people/26"
            ],
            "planets": [
                "https://swapi.info/api/planets/4",
                "https://swapi.info/api/planets/5",
                "https://swapi.info/api/planets/6",
                "https://swapi.info/api/planets/27"
            ],
            "starships": [
                "https://swapi.info/api/starships/3",
                "https://swapi.info/api/starships/10",
                "https://swapi.info/api/starships/11",
                "https://swapi.info/api/starships/12",
                "https://swapi.info/api/starships/15",
                "https://swapi.info/api/starships/17",
                "https://swapi.info/api/starships/21",
                "https://swapi.info/api/starships/22",
                "https://swapi.info/api/starships/23"
            ],
            "vehicles": [
                "https://swapi.info/api/vehicles/8",
                "https://swapi.info/api/vehicles/14",
                "https://swapi.info/api/vehicles/16",
                "https://swapi.info/api/vehicles/18",
                "https://swapi.info/api/vehicles/19",
                "https://swapi.info/api/vehicles/20"
            ],
            "species": [
                "https://swapi.info/api/species/1",
                "https://swapi.info/api/species/2",
                "https://swapi.info/api/species/3",
                "https://swapi.info/api/species/6",
                "https://swapi.info/api/species/7"
            ]
        }
    ]
    """#
    
    // MARK: - Characters
    
    static let mockCharacters: String = """
        [
            {
                "name": "Luke Skywalker",
                "height": "172",
                "mass": "77",
                "hair_color": "blond",
                "skin_color": "fair",
                "eye_color": "blue",
                "birth_year": "19BBY",
                "gender": "male",
                "homeworld": "https://swapi.info/api/planets/1",
                "films": [
                    "https://swapi.info/api/films/1",
                    "https://swapi.info/api/films/2",
                    "https://swapi.info/api/films/3",
                    "https://swapi.info/api/films/6"
                ],
                "species": [],
                "vehicles": [
                    "https://swapi.info/api/vehicles/14",
                    "https://swapi.info/api/vehicles/30"
                ],
                "starships": [
                    "https://swapi.info/api/starships/12",
                    "https://swapi.info/api/starships/22"
                ],
                "created": "2014-12-09T13:50:51.644000Z",
                "edited": "2014-12-20T21:17:56.891000Z",
                "url": "https://swapi.info/api/people/1"
            },
            {
                "name": "C-3PO",
                "height": "167",
                "mass": "75",
                "hair_color": "n/a",
                "skin_color": "gold",
                "eye_color": "yellow",
                "birth_year": "112BBY",
                "gender": "n/a",
                "homeworld": "https://swapi.info/api/planets/1",
                "films": [
                    "https://swapi.info/api/films/1",
                    "https://swapi.info/api/films/2",
                    "https://swapi.info/api/films/3",
                    "https://swapi.info/api/films/4",
                    "https://swapi.info/api/films/5",
                    "https://swapi.info/api/films/6"
                ],
                "species": ["https://swapi.info/api/species/2"],
                "vehicles": [],
                "starships": [],
                "created": "2014-12-10T15:10:51.357000Z",
                "edited": "2014-12-20T21:17:50.309000Z",
                "url": "https://swapi.info/api/people/2"
            }
        ]
        """
    
    static let mockCharacterFromURL: String = """
        {
            "name": "Luke Skywalker",
            "height": "172",
            "mass": "77",
            "hair_color": "blond",
            "skin_color": "fair",
            "eye_color": "blue",
            "birth_year": "19BBY",
            "gender": "male",
            "homeworld": "https://swapi.info/api/planets/1",
            "films": [
                "https://swapi.info/api/films/1",
                "https://swapi.info/api/films/2",
                "https://swapi.info/api/films/3",
                "https://swapi.info/api/films/6"
            ],
            "species": [],
            "vehicles": [
                "https://swapi.info/api/vehicles/14",
                "https://swapi.info/api/vehicles/30"
            ],
            "starships": [
                "https://swapi.info/api/starships/12",
                "https://swapi.info/api/starships/22"
            ],
            "created": "2014-12-09T13:50:51.644000Z",
            "edited": "2014-12-20T21:17:56.891000Z",
            "url": "https://swapi.info/api/people/1"
        }
        """
}
