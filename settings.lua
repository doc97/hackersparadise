Systems = { }

DefaultSystems = {
    ["192.168.1.1"] = {
        ["online"] = "true",
        ["name"] = "HOME",
        ["owner"] = "ADMIN",
        ["accounts"] = {
            ["ROOT"] = {
                ["username"] = "ROOT",
                ["passwd"] = "TOOR"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "OPEN" },
            ["22"] = { ["service"] = "SSH", ["status"] = "OPEN" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "CLOSED" },
            ["443"] = { ["service"] = "HTTPS", ["status"] = "CLOSED" }
        },
        ["fs"] = {
            ["BOOT"] = {
                ["BOOT.CFG"] = "HELLO WORLD\nTHE END.",
                ["SYSTEM.IMG"] = ""
            },
            ["BIN"] = { },
            ["HOME"] = {
                ["DOCUMENTS"] = { },
                ["PICTURES"] = { },
                ["CHATS"] = { }
            }
        },
        ["neighbours"] = {
            "192.168.1.2"
        },
        ["notes"] = { },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["mail"] = { },
        ["color"] = { 50, 255, 50 },
        ["firewall"] = 50,
        ["ids"] = 15
    },
    ["192.168.1.2"] = {
        ["online"] = "true",
        ["name"] = "JOHN'S PC",
        ["owner"] = "JOHN",
        ["accounts"] = {
            ["ROOTED"] = {
                ["username"] = "ROOTED",
                ["passwd"] = "DETOOR"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "OPEN" },
            ["22"] = { ["service"] = "SSH", ["status"] = "OPEN" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "CLOSED" },
            ["443"] = { ["service"] = "HTTPS", ["status"] = "CLOSED" }
        },
        ["fs"] = {
            ["BOOT"] = {
                ["BOOT.CFG"] = "UNIX=TRUE",
                ["SYSTEM.IMG"] = ""
            },
            ["BIN"] = { },
            ["HOME"] = {
                ["DOCUMENTS"] = { },
                ["PICTURES"] = { },
                ["CHATS"] = { }
            }
        },
        ["neighbours"] = {
            "192.168.1.1"
        },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["color"] = { 0, 155, 255 },
        ["firewall"] = 10,
        ["ids"] = 25
    }
}

Settings = { }

DefaultSettings = {
    ["aliases"] = { },
    ["showNotes"] = "true"
}
