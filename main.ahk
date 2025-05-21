#Requires AutoHotkey v2.0

check_menu(close:=false) {
    local value := false
    local foundx := 0
    local foundy := 0
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x.png") {
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

get_buy() {
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

buy_item() {
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/money.png")
        MouseMove(outx, outy)
        MouseClick('L', outx+2, outy)
        Sleep(1000)
        if get_buy() {
            ToolTip('Buying stock', 100, A_ScreenHeight / 2 - 50, 4)
            loop 20 {
                Sleep(200)
                MouseClick()
            }
        }   
        if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png") {
            MouseMove(outx, outy)
        }
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    } catch as e {
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    }
}

tpgear() {
    Sleep(100)
    if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/wrench.png") {
        ToolTip('checking for wrench', 100, A_ScreenHeight / 2 - 50, 4)
        MouseMove(outx, outy)
        MouseMove(outx, outy+10)
        MouseClick()
        MouseMove(500, A_ScreenHeight / 2)
        MouseClick()
        MouseClick()
        Sleep(2000)
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/search.png") {
        if not outx {
            return
        }
        ToolTip('checking search bar', 100, A_ScreenHeight / 2 - 50, 4)
        MouseMove(outx, outy)
        MouseMove(outx+2, outy)
        MouseClick()
        Send("wrench")
        tpgear
    } else if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 Images/searchx.png") {
        if not outx {
            return
        }
        ToolTip('looking for seach bar (opened)', 100, A_ScreenHeight / 2 - 50, 4)
        MouseMove(outx, outy)
        MouseMove(outx+2, outy)
        MouseClick()
        tpgear
    } else {
        ToolTip('opening inventory', 100, A_ScreenHeight / 2 - 50, 4)
        Send("``")
        tpgear
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

check_stock(gear:=false) {
    global funcran
    funcran := true
    if !WinExist("Roblox") {
        MsgBox "Please open roblox!!"
        return
    } else {
        try {
            WinActivate('Roblox')
        } catch {
            return
        } 
    }
    if check_menu() {
        if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png") {
            MouseMove(outx, outy)
            MouseMove(outx+2, outy)
        }
        if gear {
            ToolTip('Scrolling to top', 100, A_ScreenHeight / 2 - 50, 4)
            Sleep(10)
            Send "{WheelUp 100}"
            Sleep(200)
            ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
            loop 50 {
                if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/favtool.png") {
                    ToolTip('Stopped at stopping point', 100, A_ScreenHeight / 2 - 50, 4)
                    break
                }
                buy_item()
                Send "{WheelDown}"
                Send "o" ; just incase it zooms in all the way
                Sleep(200)
            }
            return
        } else {
            ToolTip('Scrolling to bottom', 100, A_ScreenHeight / 2 - 50, 4)
            Sleep(10)
            Send "{WheelDown 100}"
            Sleep(200)
            ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
            loop 50 {
                if ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/daffodil.png") {
                    ToolTip('Stopped at stopping point', 100, A_ScreenHeight / 2 - 50, 4)
                    break
                }
                buy_item()
                Send "{WheelUp}"
                Send "o" ; just incase it zooms in all the way
                Sleep(200)
            }
            ;loop 10 {
            ;    if check_menu(true) {
            ;        break
            ;    }
            ;    Sleep(100)
            ;}
            ;check_stock(true) 
            return      
        }

    } else {
        ToolTip('opening shop', 100, A_ScreenHeight / 2 - 50, 4)
        if gear {
            tpgear()
            Send("{WheelUp 100}")
            Send("{WheelDown 10}")
        }
        loop 200 {
            if Mod(A_Index, 20) == 0 and not gear {
                tpseedshop() 
            } else if Mod(A_Index, 75) == 0 and gear {
                tpgear()
                Sleep(1000)
            }
            if gear {
                ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "*100 Images/gear.png")
                if outx {
                    MouseMove(outx, outy)
                    MouseMove(outx+2, outy)
                    MouseClick()
                    sleep(200)
                }
            }
            if check_menu() {
                if gear {
                    check_stock(true)
                } else {
                    check_stock
                }
                return
            }
            Send "{Left down}"
            Send "e"
            Sleep(100)
            Send "{Left up}"
        }
        funcran := false
    }
}

funcran := false
runfunc() {
    global funcran
    if (Mod(A_Min, 5) == 0) {
        if not funcran {
            check_stock()
        }
    } else {
        funcran := false
        ToolTip('Waiting for restock', 100, A_ScreenHeight / 2 - 50, 4)
    }
}

SetTimer(UpdateToolTip, 1000)

Running := false

^o:: {
    global Running
    if Running {
        Reload
    } else {
        Running := true
        check_stock()
        SetTimer(runfunc, 10000)
    }
}

Runtime := 0

UpdateToolTip() {
    global Running
    global funcran
    global Runtime
    if Running {
        Runtime++
        ToolTip('Macro running', 100, A_ScreenHeight / 2, 2)
        ToolTip('RunTime: ' Runtime, 100, A_ScreenHeight / 2 - 25, 1)
    } else {
        Runtime := 0
        ToolTip(,,,1)
        ToolTip('Press `'Ctrl + O`' to start' , 100, A_ScreenHeight / 2, 2)
    }
    ToolTip('Press `'Ctrl + Q`' to close' , 100, A_ScreenHeight / 2 + 25, 3)
    
    return
}

^t:: check_stock(true)

^q:: ExitApp