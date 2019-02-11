Settings = { }
DefaultSettings = {
    ["aliases"] = { },
    ["showNotes"] = "false"
}

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
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["route"] = "",
        ["color"] = { 0.2, 1, 0.2 },
        ["firewall"] = 50,
        ["ids"] = 15
    },
    ["192.168.1.2"] = {
        ["online"] = "true",
        ["name"] = "TEST COMPUTER",
        ["owner"] = "R33T",
        ["accounts"] = {
            ["ROOT"] = {
                ["username"] = "ROOT",
                ["passwd"] = "TOOR"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "OPEN" },
            ["22"] = { ["service"] = "SSH", ["status"] = "CLOSED" },
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
                ["DOCUMENTS"] = {
                    ["FILE"] = "I AM A FILE"
                },
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
        ["route"] = "",
        ["color"] = { 0, 0.6, 1 },
        ["firewall"] = 0,
        ["ids"] = 60
    },
    ["192.168.1.3"] = {
        ["online"] = "true",
        ["name"] = "ALICE'S LAPTOP",
        ["owner"] = "ALICE",
        ["accounts"] = {
            ["ALICE"] = {
                ["username"] = "ALICE",
                ["passwd"] = "ECILA"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "OPEN" },
            ["22"] = { ["service"] = "SSH", ["status"] = "CLOSED" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "OPEN" },
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
            "192.168.1.2",
            "192.168.1.4"
        },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["route"] = "",
        ["color"] = { 0.6, 0, 0.6 },
        ["firewall"] = 10,
        ["ids"] = 25
    },
    ["192.168.1.4"] = {
        ["online"] = "true",
        ["name"] = "ALICE'S PC",
        ["owner"] = "ALICE",
        ["accounts"] = {
            ["ALICE"] = {
                ["username"] = "ALICE",
                ["passwd"] = "ECILA2"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "CLOSED" },
            ["22"] = { ["service"] = "SSH", ["status"] = "CLOSED" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "OPEN" },
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
            "192.168.1.2",
            "192.168.1.3",
            "192.168.1.5"
        },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["route"] = "",
        ["color"] = { 1, 0, 1 },
        ["firewall"] = 25,
        ["ids"] = 15
    },
    ["192.168.1.5"] = {
        ["online"] = "true",
        ["name"] = "HAVEN",
        ["owner"] = "G0DSP33D",
        ["accounts"] = {
            ["G0DSP33D"] = {
                ["username"] = "G0DSP33D",
                ["passwd"] = "OMGWTFBBQ"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "CLOSED" },
            ["22"] = { ["service"] = "SSH", ["status"] = "CLOSED" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "CLOSED" },
            ["443"] = { ["service"] = "HTTPS", ["status"] = "OPEN" }
        },
        ["fs"] = {
            ["BOOT"] = {
                ["BOOT.CFG"] = "UNIX=TRUE",
                ["SYSTEM.IMG"] = ""
            },
            ["BIN"] = { },
            ["HOME"] = {
                ["DOCUMENTS"] = {
                    ["MESSAGE.TXT"] = "HELLO! SEEMS YOU ARE RATHER CURIOUS. HERE IS A LITTLE TEST FOR YOU:\n273.56.4.2"
                },
                ["PICTURES"] = { },
                ["CHATS"] = { }
            }
        },
        ["neighbours"] = {
            "192.168.1.4"
        },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["route"] = "",
        ["color"] = { 0, 1, 1 },
        ["firewall"] = 40,
        ["ids"] = 10
    },
    ["273.56.4.2"] = {
        ["online"] = "true",
        ["name"] = "PENTEST LAB 01",
        ["owner"] = "G0DSP33D",
        ["accounts"] = {
            ["G0DSP33D"] = {
                ["username"] = "G0DSP33D",
                ["passwd"] = "OMGWTFBBQ"
            }
        },
        ["ports"] = {
            ["21"] = { ["service"] = "FTP", ["status"] = "OPEN" },
            ["22"] = { ["service"] = "SSH", ["status"] = "OPEN" },
            ["80"] = { ["service"] = "HTTP", ["status"] = "OPEN" },
            ["443"] = { ["service"] = "HTTPS", ["status"] = "OPEN" }
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
                ["CHATS"] = {
                    ["CR3SC3NT"] = { },
                    ["ZEUS"] = {},
                    ["L0CALH0ST"] = {
                        ["INVITE.TXT"] = "CONGRATULATIONS!\nYOU HAVE OFFICIALLY BEEN INVITED TO PUPPYT33RS. IF YOU ARE INTERESTED IN JOINING,\nPLEASE COPY THIS INVITE TO YOUR OWN MACHINE."
                    },
                }
            }
        },
        ["neighbours"] = {
            "192.168.1.4"
        },
        ["processes"] = {
            ["0"] = "ROOT"
        },
        ["route"] = "",
        ["color"] = { 0, 1, 1 },
        ["firewall"] = 40,
        ["ids"] = 10
    }
}

Env = { }
DefaultEnv = {
    ["reboot"] = { }
}

PlayerInfo = { }
DefaultPlayerInfo = {
    ["mail"] = { },
    ["notes"] = { },
    ["knownSystems"] = {
        ["192.168.1.1"] = true
    }
}
