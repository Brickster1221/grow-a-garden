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
        MouseMove(foundx-2, foundy, 10)
    }
    return value
}

buy_item() {
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/money.png")
        MouseMove(outx, outy)
        MouseClick('L', outx-2, outy)
        Sleep(1000)
        if get_buy() {
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
        return
    } catch as e {
        return
    }
}

stopping_point() {
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/daffodil.png")
        if outx {
            return true
        }
    } catch as e {
        return false
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
            MouseMove(outx-2, outy)
        } catch as e {
            return
        }
        Sleep(10)
        Send "{WheelDown 100}"
        Sleep(100)
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
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp.png")
        if outx {
            MouseMove(outx, outy, 10)
            MouseClick('L', outx-2, outy)
        } else If (outx) {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp-sel.png")
            MouseMove(outx, outy, 10)
            MouseClick('L', outx-2, outy)
        }
        loop 100 {
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
    }
}

SetTimer(UpdateToolTip, 1000)

Running := false

^o:: {
    global Running
    if Running {
        Running := false
        SetTimer(runfunc, 0)
    } else {
        Running := true
        if not funcran {
            check_stock()
        }
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
        ToolTip(,,,4)
    } else {
        Runtime := 0
        ToolTip('RunTime: ' Runtime, 100, A_ScreenHeight / 2 - 25, 1)
        ToolTip('Press `'Ctrl + O`' to start' , 100, A_ScreenHeight / 2, 4)
    }
    ToolTip('Press `'Ctrl + Q`' to close' , 100, A_ScreenHeight / 2 + 25, 3)
    
    return
}

^q:: ExitApp