#Requires AutoHotkey v2.0

check_menu(close:=false) {
    local value := false
    local foundx := 0
    local foundy := 0
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x.png")
        if outx {
            foundx := outx
            foundy := outy
            value := true
        }
    }
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x-sel.png")
        if outx {
            foundx := outx
            foundy := outy            
            value := true
        }
    }
    if close {
        MouseMove(foundx, foundy, 0)
        MouseClick()
    }
    return value
}

get_buy() {
    local value := false
    local foundx := 0
    local foundy := 0
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy.png")
        if outx {
            foundx := outx
            foundy := outy
            value := true
        }
    }
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy-sel.png")
        if outx {
            foundx := outx
            foundy := outy            
            value := true
        }
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
        try {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png")
            MouseMove(outx, outy)
        } catch as e {
            return
        }
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    } catch as e {
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        return
    }
}

stopping_point() {
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/daffodil.png")
        if outx {
            ToolTip('Stopped at stopping point', 100, A_ScreenHeight / 2 - 50, 4)
            return true
        }
    } catch as e {
        return false
    }
}

tpseedshop() {
    ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp.png")
    if outx {
        MouseMove(outx, outy, 10)
        MouseClick('L', outx+2, outy)
    } else {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp-sel.png")
        MouseMove(outx, outy, 10)
        MouseClick('L', outx+2, outy)
    }
}

check_stock() {
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
        try {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png")
            MouseMove(outx, outy)
            MouseMove(outx+2, outy)
        } catch as e {
            return
        }
        ToolTip('Scrolling to bottom', 100, A_ScreenHeight / 2 - 50, 4)
        Sleep(10)
        Send "{WheelDown 100}"
        Sleep(100)
        ToolTip('Scrolling through shop', 100, A_ScreenHeight / 2 - 50, 4)
        loop 50 {
            if stopping_point() {
                break
            }
            buy_item()
            Send "{WheelUp}"
            Send "o" ; just incase it zooms in all the way
            Sleep(200)
        }
    } else {
        ToolTip('opening shop', 100, A_ScreenHeight / 2 - 50, 4)
        tpseedshop()
        loop 100 {
            if Mod(A_Index, 10) == 0 {
                tpseedshop()
            }
            if check_menu() {
                check_stock
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

^q:: ExitApp