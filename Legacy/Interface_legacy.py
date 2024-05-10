
interfacelayer1 = pg.Surface((par.size[0], 200))
interfacelayer1.fill(c.BROWN)

InterfaceStartPositionX = 0
InterfaceStartPositionY = 0

index = 0

class infLOAD():
    HealthNum = 0
    CoinsNum = 0
    KeysNum = 0
    def __init__(self):
        global HealthNUM,InterfaceStartPositionX,InterfaceStartPositionY,is_first_try
        InterfaceStartPositionX = 10
        InterfaceStartPositionY = par.size[1] - 370 * par.Window.GetScale(self)
        infLOAD.DrawIcon(self)
        infLOAD.DrawHUD(self)
        #infLOAD.PrintDEBUG(self)
        infLOAD.DrawKeys(self)
        infLOAD.DrawCoins(self)
        infLOAD.DrawHealt(self)
        infLOAD.DrawFPS(self)

        ########


    def PrintDEBUG(self):
        print(ps.Player.GetHP(self))
        ps.Player.GetDataAll(self)

    def DrawHealt(self):
        HPFILLER = pg.Surface((3.43 * par.Window.GetScale(self), 33 * par.Window.GetScale(self)))
        HPFILLER.fill(c.RED)

        HPBACKFILLER = pg.Surface((275 * par.Window.GetScale(self), 30 * par.Window.GetScale(self)))
        HPBACKFILLER.fill(c.GRAY)

        StartPosHealthX = InterfaceStartPositionX + (210 * par.Window.GetScale(self))
        StartPosHealthY = InterfaceStartPositionY + (140 * par.Window.GetScale(self))

        TextPosHealthX = StartPosHealthX + 40*par.Window.GetScale(self)
        TextPosHealthY = StartPosHealthY + 10*par.Window.GetScale(self)
        HealthNum = ps.Player.GetHP(self)
        X = 12 * par.Window.GetScale(self)
        Y = 4 * par.Window.GetScale(self)
        par.game_display.blit(HPBACKFILLER, (StartPosHealthX+(12*par.Window.GetScale(self)), StartPosHealthY+(4*par.Window.GetScale(self))))
        if HealthNum > 101:
            HealthNum = 100
        for i in range(HealthNum):
            X += (3.43* par.Window.GetScale(self))-(0.7*par.Window.GetScale(self))
            par.game_display.blit(HPFILLER, (StartPosHealthX + X, StartPosHealthY + Y)) #1
        sHN = str(HealthNum)

        text1 = f.font1_FORHUD.render('health          ' + sHN + '/100', False, c.DARKBROWN)

        text1.convert_alpha()
        par.game_display.blit(text1, (TextPosHealthX, TextPosHealthY))#2

        par.game_display.blit(pg.transform.scale(tx.assets['healthB1'], (300 * par.Window.GetScale(self), 40 * par.Window.GetScale(self))), (StartPosHealthX, StartPosHealthY)) #3

    def DrawCoins(self):
        CoinsNum = ps.Player.GetCoins(self)
        CoinsKeysX = 401*par.Window.GetScale(self)
        CoinsKeysY = par.size[1] - 118*par.Window.GetScale(self)
        if CoinsNum > 9:
            CoinsKeysX = 395*par.Window.GetScale(self)
        if CoinsNum > 19:
            CoinsKeysX = 393*par.Window.GetScale(self)
        if CoinsNum > 99:
            CoinsKeysX = 386*par.Window.GetScale(self)
        CoinsNum_text = str(CoinsNum)
        text = f.font1_SMALL.render(CoinsNum_text, False, c.BLACK)
        par.game_display.blit(text, (CoinsKeysX, CoinsKeysY))


    def DrawKeys(self):
        global TextKeysX
        KeysNum = ps.Player.GetKeys(self)
        TextKeysX = 264*par.Window.GetScale(self)
        TextKeysY = par.size[1] - 118 *par.Window.GetScale(self)
        if KeysNum > 9:
            TextKeysX = 258*par.Window.GetScale(self)
        if KeysNum > 19:
            TextKeysX = 255*par.Window.GetScale(self)
        if KeysNum > 99:
            TextKeysX = 252*par.Window.GetScale(self)
        KeysNum_text = str(KeysNum)
        font1_SMALL = pg.font.Font('fonts/Font1.ttf', math.ceil(20 * par.Window.GetScale(0)))
        text = font1_SMALL.render(KeysNum_text, False, c.BLACK)
        par.game_display.blit(text, (TextKeysX, TextKeysY))

    def DrawHUD(self): #ready
        par.game_display.blit(pg.transform.scale(tx.assets['hud1'], (550 * par.Window.GetScale(self), 320 * par.Window.GetScale(self))), (InterfaceStartPositionX, InterfaceStartPositionY))
    def DrawIcon(self): #ready
        par.game_display.blit(pg.transform.scale(tx.assets['icon1'], (150 * par.Window.GetScale(self), 150 * par.Window.GetScale(self))), (InterfaceStartPositionX+35*par.Window.GetScale(self), InterfaceStartPositionY+135*par.Window.GetScale(self)))

    def DrawFPS(self):

        fpsblock = pg.Surface((50, 30))
        fpsblock.fill(c.WHITE)
        fps = round(par.clock.get_fps())
        #if fps < 58:
            #print(fps, "ПОНИЖЕН ФПС")
        #else:
            #print(fps)
        fps1 = str(fps)
        text1 = f.font1_SMALL.render(fps1, False, c.DARKBROWN)
        text1.convert_alpha()
        fpsblock.convert_alpha()
        par.game_display.blit(fpsblock, (0, 0))
        par.game_display.blit(text1, (2, 0))