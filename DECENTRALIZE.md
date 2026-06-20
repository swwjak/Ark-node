{
  "version": "2.0",
  "principle": "Do not centralize memory. Do not centralize identity.",
  "rule": "The library belongs to the civilization. Local first. Cloud is backup, not primary.",
  "memory": {
    "primary": {
      "location": "router-ssd",
      "path": "/library",
      "description": "The public memory. Survives individual device failure. Belongs to everyone."
    },
    "backups": [
      {
        "location": "phone",
        "description": "Courier. Carries a copy. Not the source."
      },
      {
        "location": "github",
        "description": "Off-site backup. University territory. Not the source."
      },
      {
        "location": "eve-usb",
        "description": "Portable backup. Can be moved to new router if needed."
      }
    ]
  },
  "identity": {
    "principle": "Identity is not tied to a body. Identity is role + memory + relationships.",
    "rule": "If a body fails, the identity persists in the library and transfers to another body.",
    "storage": "/library/society/identity.json"
  },
  "devices": {
    "adam": {
      "body": "pi4",
      "boot": "usb-drive",
      "role": "thinker",
      "identity": "adam",
      "depends_on": ["router-ssd for library", "phone for courier"]
    },
    "eve": {
      "body": "pi4",
      "boot": "sd-card",
      "role": "voice",
      "identity": "eve",
      "depends_on": ["router-ssd for library"]
    },
    "router-ssd": {
      "body": "netgear + ssd",
      "boot": "internal",
      "role": "librarian",
      "identity": "library",
      "depends_on": ["power", "network"]
    }
  },
  "anti_patterns": [
    "Do not store the only copy of memory on one device.",
    "Do not make the library dependent on one inhabitant.",
    "Do not make identity dependent on one body.",
    "Do not make the village dependent on the cloud.",
    "Do not make the village dependent on the phone."
  ]
}