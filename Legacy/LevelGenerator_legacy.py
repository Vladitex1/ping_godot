import pygame as pg
import Colors as clr
import Textures as tx
import Parameters as par
import LevelMatrixCreator as lg
import Doors as dr
import Interface_legacy as inf

textureON = False
ColorON = False

index = 0
index2 = 0
index3 = 0
DoorColisionID = 0
LeftDoorColisionID = 0
RightDoorColisionID = 0
normal = 50
normal2 = 450
hndr = 100
kf = 0
id1 = 0


class GKF:

    def __init__(self):
        global kf
        kf = 90
    def get_kf(self):
        return kf
    def set_kf(self,set):
        global kf
        kf = set
    def kfPLUS(self):
        GKF.set_kf(self,GKF.get_kf(self) * 2)

    def kfMINUS(self):
        GKF.set_kf(self,GKF.get_kf(self) / 2)

GetKF = GKF()


index = GetKF.get_kf()
index3 = (GetKF.get_kf() * hndr) / normal  # 120
index2 = (normal2 * index3) / hndr  # 480


buildX = 500
buildY = 80
buildW = GetKF.get_kf()
buildH = GetKF.get_kf()




groundblu = pg.Surface((index, index))
groundgrn = pg.Surface((index, index))
groundred = pg.Surface((index, index))
groundblu.fill(clr.BLUE)
groundgrn.fill(clr.GREEN)
groundred.fill(clr.RED)


Texture = pg.transform.scale(groundgrn, (GetKF.get_kf(), GetKF.get_kf())) 
Texture2 = pg.transform.scale(groundred, (GetKF.get_kf(), GetKF.get_kf())) 
Texture.set_alpha(0)
Texture2.set_alpha(0)



blocks = []
doors = []
doorstougles = []
shops = []
enemy = []
enemyinfomatrix = []
indexld = 0

is_first_try = True
is_first_try2 = True

class Ground:
    global KF


    def __init__(self):
        global is_first_try2,indexld
        Ground.LoadTextureLayer(self, Ground.GetBuildX(self), Ground.GetBuildY(self), GetKF.get_kf())
        Ground.LoadObjectsLayer(self, Ground.GetBuildX(self), Ground.GetBuildY(self), GetKF.get_kf())
        Ground.LoadDoors(self, GetKF.get_kf())
        #print(indexld)
        if is_first_try2:
            Ground.LoadColision(self, Ground.GetBuildX(self), Ground.GetBuildY(self), GetKF.get_kf())
            #Ground.LoadEnemyMatrix(self, Ground.GetBuildX(self), Ground.GetBuildY(self), GetKF.get_kf())
            is_first_try2 = False


    def GetBuildY(self):
        global buildY
        BuildY = buildY
        return BuildY
    def GetBuildX(self):
        global buildX
        BuildX = buildX
        return BuildX
    def SetBuildXY(self, build1, build2):
        global buildX,buildY,blocks
        blocks = []
        buildX = build1
        buildY = build2


    def LoadDoors(self, KF):
        global is_first_try, doorstougles, doors, Texture, Texture2, DoorColisionID
        if is_first_try:
            is_first_try = False
            for i in range(len(lg.col_matrix)):
                for j in range(len(lg.col_matrix[i])):
                    if lg.col_matrix[i][j] == "4":
                        dr.Doors.InsertNewDoor(self, 0, 0, 0, 0, 0, 0)
        doorstougles = []
        doors = []
        for id in range(DoorColisionID):
            add = par.game_display.blit(Texture, (
                dr.Doors.GetInfo(self, "ID", id, 3), dr.Doors.GetInfo(self, "ID", id, 4)))
            doorstougles.append(add)
            #print(doorstougles,dr.Doors.GetInfo(self, "ID", id, 7))
            #print(dr.Doors.GetInfo(self, "ID", id, 7))
            if dr.Doors.GetInfo(self, "ID", id, 7) == 1:
                add = par.game_display.blit(Texture2,(dr.Doors.GetInfo(self, "ID", id, 1), dr.Doors.GetInfo(self, "ID", id, 2)))
                doors.append(add)
                #Отрисовка текстур дверей
                Texturedr1 = pg.transform.scale(tx.assets['door2'], (KF, KF))
                par.game_display.blit(Texturedr1, (dr.Doors.GetInfo(self, "ID", id, 1), dr.Doors.GetInfo(self, "ID", id, 2)))
                Texturedr2 = pg.transform.scale(tx.assets['door1'], (KF, KF))
                par.game_display.blit(Texturedr2, (dr.Doors.GetInfo(self, "ID", id, 1), dr.Doors.GetInfo(self, "ID", id, 2)-KF))





    def LoadColision(self, buildX, buildY, KF):
        coefficient = KF
        global buildW, buildH, index, doors, blocks,shops, DoorColisionID, LeftDoorColisionID, RightDoorColisionID

        blocks = []
        shops = []

        DoorColisionID = 0
        LeftDoorColisionID = -1
        RightDoorColisionID = -1

        for i in range(len(lg.col_matrix)):
            for j in range(len(lg.col_matrix[i])):
                if lg.col_matrix[i][j] == "*":
                    buildY += GetKF.get_kf()
                    buildX = Ground.GetBuildX(self)

                if lg.col_matrix[i][j] == "1":
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "2":
                    Texture = pg.transform.scale(groundblu, (coefficient, coefficient)) 
                    add = par.game_display.blit(Texture, (buildX, buildY))
                    blocks.append(add)
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "5":
                    add = par.game_display.blit(groundred, (buildX, buildY))
                    blocks.append(add)
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "6":
                    add = par.game_display.blit(groundgrn, (buildX, buildY))
                    shops.append(add)
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "E":
                    add = par.game_display.blit(groundgrn, (buildX, buildY))
                    shops.append(add)
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "4":   #дверь
                    dr.Doors.RefreshPosition(self, buildX, buildY, DoorColisionID)
                    DoorColisionID += 1
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "9":  # дверь
                    LeftDoorColisionID += 1
                    dr.Doors.SetOpenerBlockPosition(self, buildX, buildY, LeftDoorColisionID, 0)
                    buildX += GetKF.get_kf()

                if lg.col_matrix[i][j] == "0":  # дверь
                    RightDoorColisionID += 1
                    dr.Doors.SetOpenerBlockPosition(self, buildX, buildY, RightDoorColisionID, 1)
                    buildX += GetKF.get_kf()


    def LoadTextureLayer(self, buildX, buildY, KF):
        global buildW, buildH
        # Выводим матрицу на экран
        coefficient = KF
        for i in range(len(lg.NormalMatrix)):
            for j in range(len(lg.NormalMatrix[i])):
                if lg.NormalMatrix[i][j] == "*":
                    buildY += GetKF.get_kf()
                    buildX = Ground.GetBuildX(self)
                if lg.NormalMatrix[i][j] == "0":
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "1":
                    Texture = pg.transform.scale(tx.assets['wallUP_DOWN'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "2":
                    Texture = pg.transform.scale(tx.assets['wallLEFT_RIGHT'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "3":
                    Texture = pg.transform.scale(tx.assets['wallLEFT_UP'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "4":
                    Texture = pg.transform.scale(tx.assets['wallRIGHT_UP'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "5":
                    Texture = pg.transform.scale(tx.assets['wallLEFT_DOWN'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "6":
                    Texture = pg.transform.scale(tx.assets['wallRIGHT_DOWN'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "U":
                    Texture = pg.transform.scale(tx.assets['wallU'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "N": #Ground
                    Texture = pg.transform.scale(tx.assets['wallN'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "T": #Ground
                    Texture = pg.transform.scale(tx.assets['wallT'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "F": #Ground
                    Texture = pg.transform.scale(tx.assets['wallF'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "D": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "b": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "d": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "S": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "s": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "Z": #Ground
                    Texture = pg.transform.scale(tx.assets['wallS'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "P": #Ground
                    Texture = pg.transform.scale(tx.assets['wallP'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "L": #Ground
                    Texture = pg.transform.scale(tx.assets['wallL'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "R": #Ground
                    Texture = pg.transform.scale(tx.assets['wallR'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.NormalMatrix[i][j] == "E": #Ground
                    Texture = pg.transform.scale(tx.assets['wallGROUND'], (coefficient, coefficient)).convert()
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()


    def LoadObjectsLayer(self, buildX, buildY, KF):
        global buildW, buildH, doors
        coefficient = KF
        # Выводим матрицу на экран
        for i in range(len(lg.objects_matrix)):
            for j in range(len(lg.objects_matrix[i])):
                if lg.objects_matrix[i][j] == "*":
                    buildY += GetKF.get_kf()
                    buildX = Ground.GetBuildX(self)
                if lg.objects_matrix[i][j] == "0":
                    buildX += GetKF.get_kf()
                if lg.objects_matrix[i][j] == "1":
                    Texture = pg.transform.scale(tx.assets['door1'], (coefficient, coefficient))
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.objects_matrix[i][j] == "3":
                    buildX += GetKF.get_kf()

                if lg.objects_matrix[i][j] == "S":
                    Texture = pg.transform.scale(tx.assets['shop1'], (coefficient, coefficient))
                    par.game_display.blit(Texture, (buildX, buildY-coefficient))
                    Texture = pg.transform.scale(tx.assets['shop2'], (coefficient, coefficient))
                    par.game_display.blit(Texture, (buildX, buildY))
                    buildX += GetKF.get_kf()
                if lg.objects_matrix[i][j] == "s":
                    buildX += GetKF.get_kf()
                if lg.objects_matrix[i][j] == "d":
                    buildX += GetKF.get_kf()
                if lg.objects_matrix[i][j] == "b":
                    buildX += GetKF.get_kf()


    def LoadEnemyMatrix(self, buildX, buildY, KF):
        global buildW, buildH, enemy,enemyinfomatrix,id1
        enemy = []
        enemyinfomatrix = []
        id1 = 0
        HP = 100
        for i in range(len(lg.NormalMatrix)):
            for j in range(len(lg.NormalMatrix[i])):
                if lg.objects_matrix[i][j] == "*":
                    buildY += GetKF.get_kf()
                    buildX = Ground.GetBuildX(self)
                if lg.EnemyMatrix[i][j] == "0":
                    buildX += GetKF.get_kf()
                if lg.EnemyMatrix[i][j] == "E":
                    id1 += 1
                    add2 = [id1, buildX, buildY, HP]
                    enemyinfomatrix.append(add2)
                    buildX += Ground.GetBuildX(self)

        #print(enemyinfomatrix)