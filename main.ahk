#Requires AutoHotkey v2.0

in_eventshop := true
seen_message := false

check_menu(close:=false) { ;checks if the menu is open
    local value := false
    local foundx := 0
    local foundy := 0
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 Images/x.png") {
        foundx := outx
        foundy := outy
        value := true
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x-sel.png") {
        foundx := outx
        foundy := outy            
        value := true
    }
    if close and value {
        MouseMove(foundx, foundy, 0)
        MouseMove(foundx+2, foundy, 0)
        MouseClick()
    }
    return value
}

get_buy() { ; finds the buy button for items
    local value := false
    local foundx := 0
    local foundy := 0
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy.png") {
        foundx := outx
        foundy := outy
        value := true
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy-sel.png") {
        foundx := outx
        foundy := outy            
        value := true
    }
    
    if value {
        MouseMove(foundx, foundy, 10)
        MouseMove(foundx+2, foundy, 10)
    }
    return value
}

buy_item(open:=false) { ; checks to see if there is an item in stock, then buy it
    try {
        if not open {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/money.png")
            MouseMove(outx, outy)
            MouseClick('L', outx+2, outy)          
        }
        Sleep(1000)
        if get_buy() {
            ToolTip('Buying stock', 100, A_ScreenHeight / 2 - 50, 4)
            loop 20 {
                Sleep(200)
                MouseClick() ; buys 20 of the stock
            }
        }   
        if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 Images/scroll.png") {
            MouseMove(outx, outy)
        }
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    } catch as e {
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    }
}

tpseedshop() {
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp.png") {
        MouseMove(outx, outy, 10)
        MouseClick('L', outx+2, outy)
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp-sel.png") {
        MouseMove(outx, outy, 10)
        MouseClick('L', outx+2, outy)            
    }
}

check_stock() {
    if not checkdisconnect() {
        return
    } 
    global funcran
    funcran := true
    try {
        WinActivate('Roblox')
    } catch {
        return
    }
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*80 Images/backpack.png") {
        Send('``')
    }    
    global in_eventshop
    if check_menu() {
        if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*10 Images/scroll.png") {
            MouseMove(outx, outy)
            MouseMove(outx+2, outy)
        }
        ToolTip('Scrolling to top', 100, A_ScreenHeight / 2 - 50, 4)
        Sleep(10)
        Send "{WheelUp 100}"
        Sleep(200)          
        if in_eventshop {
            if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/event/pack.png") { ; finds the seed pack
                MouseMove(outx, outy)
                MouseClick('L',outx+2, outy)
                buy_item(true)
            }
            ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
            loop 50 {
                if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/event/egg.png") { ; finds the seed pack
                    MouseMove(outx, outy)
                    MouseClick('L',outx+2, outy)
                    buy_item(true)
                    return
                }
                Send "{WheelDown}"
                Send "o" ; just incase it zooms in all the way
                Sleep(200)
            }
        } else {
            ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
            loop 50 {
                buy_item()
                Send "{WheelDown}"
                Send "o" ; just incase it zooms in all the way
                Sleep(200)
            }
            return      
        }

    } else {
        if in_eventshop { ;checks to see if the shop is even open
            ToolTip('checking for shop', 100, A_ScreenHeight / 2 - 50, 4)
            loop {
                if A_Index == 5 {
                    ToolTip('shop not found, doing default procedure', 100, A_ScreenHeight / 2 - 50, 4)
                    in_eventshop := false
                    break
                }
                if check_menu() {
                    break
                }
                Sleep(500)
            }
            check_stock
            return
        } else {
            ToolTip('opening shop', 100, A_ScreenHeight / 2 - 50, 4)
        }
        loop 200 {
            if Mod(A_Index, 20) == 0 {
                tpseedshop() 
            }
            if check_menu() {
                check_stock
                return
            }
            ; turns and presses e until the shop opens
            Send "{Left down}"
            Send "e"
            Sleep(100)
            Send "{Left up}"
        }
        funcran := false
    }
}

checkdisconnect() {
    try {
        WinActivate('Roblox')
    }
    global in_eventshop
    if !ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*5 Images/something.png") {
        in_eventshop := false
        ToolTip('You disconnected, trying to reconnect', 100, A_ScreenHeight / 2 - 50, 4)
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 Images/reconnect.png")
        if outx {
            MouseMove(outx,outy)
            MouseMove(outx+2,outy)
            MouseClick()
            ToolTip('pressed reconnect button', 100, A_ScreenHeight / 2 - 50, 4)
            Sleep(20000) ; delay to load in
            MouseClick()
            return true
        } else if !WinExist("Roblox") {
            MsgBox "Please open roblox!!, im too lazy to make it reconnect rn"
        }
        return false
    } else {
        return true
    }
}

search(phrase) {
    sleep(100)
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/searchx.png") {
        MouseMove(outx,outy)
        MouseClick('L',outx+2,outy) 
        search(phrase)
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/search.png") {
        MouseMove(outx,outy)
        MouseClick('L',outx+2,outy)
        Sleep(100)
        Send phrase
        Send('{Enter}')
    } else {
        Send '``'
        search(phrase)
    }
}

funcran := false
runfunc() {
    global funcran
    if in_eventshop and not funcran {
        ToolTip('doing honey machine', 100, A_ScreenHeight / 2 - 50, 4)
        search('polli')
        Sleep(100)
        if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/event/pollinated.png") {
            MouseMove(outx,outy)
            Send 'e' ; gets honey
            Sleep(1000)
            Send 'e' ; just in case a fruit is already selected
            Sleep(100)
            MouseClick('L',outx+2,outy)
            Sleep(100)
            Send 'e' ; if it wasnt selected
        }
    }
    if in_eventshop and not funcran and (Mod(A_Min, 30) == 0) {
        check_stock()
    } if (Mod(A_Min, 5) == 0) and not funcran and not in_eventshop {
        check_stock()
    } else if not (Mod(A_Min, 5) == 0) {
        funcran := false
        ToolTip('Waiting for restock', 100, A_ScreenHeight / 2 - 50, 4)
    }
}

Running := false

^p:: {
    global Running
    global seen_message
    if not seen_message {
        seen_message := true
        MsgBox "You currently have event shop mode on, meaning you are in the event shop while facing the honey maker`nif you are currently not in the shop or dont want to be, disable in_eventshop at the top of main.ahk`nplease close this message and start again, if you wish to never see this again enable seen_message in main.ahk"
        return
    }
    if not Running {
        Running := true
        check_stock()
        SetTimer(runfunc, 10000)
    }
}

^o:: {
    Reload
}

Runtime := 0

SetTimer(UpdateToolTip, 1000) ; updates the tooltips every second
UpdateToolTip() {
    global Running
    global funcran
    global Runtime
    if Running {
        Runtime++
        ToolTip('Macro running, press `'ctrl + O`' to stop', 100, A_ScreenHeight / 2, 2)
        ToolTip('RunTime: ' Runtime, 100, A_ScreenHeight / 2 - 25, 1)
    } else {
        Runtime := 0
        ToolTip(,,,1)
        ToolTip('Press `'ctrl + P`' to start' , 100, A_ScreenHeight / 2, 2)
    }
    ToolTip('Press `'Q`' to close' , 100, A_ScreenHeight / 2 + 25, 3)
    
    return
}

^t:: {
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*80 Images/backpack.png") {
        Send('``')
    }  
}

q:: ExitApp