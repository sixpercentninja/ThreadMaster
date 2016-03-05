//
//  Player.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 17/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import CoreData

class Player: Character {
    static let mainPlayer = Player.test()
    
    var level: Int = 1
    var totalExperience: Int = 100 {
        didSet {
            calculateLevel()
        }
    }
    
    class func test() -> Player{
        let savePlayer = SavePlayer.currentPlayer
        let player = Player(imageNamed: SKTextureAtlas(named: "mainCharacter").textureNames.first!, maxHP: 50, charName: "Kumo", attribute: Attribute.Neutral)
        player.totalExperience = savePlayer.totalExperience as! Int
        player.maxHP = savePlayer.maxHP as! Int

        for playerSkill in savePlayer.playerSkill!{
            let playerSkill = playerSkill as! PlayerSkill
            let skillName = playerSkill.skillName!
            let skill = SkillType(rawValue: skillName)!.singleInstance
            skill.useCount = Int(playerSkill.useCount!)
            player.skills[skillName] = skill
        }
        
        return player
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        totalExperience = 0
        super.init(texture: texture, color: color, size: size)
    }
    
    override init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        totalExperience = 0
        super.init(imageNamed: imageNamed, maxHP: maxHP, charName: charName, attribute: attribute)
        self.skills["Whip"] = Whip()
        self.skills["Constrict"] = Constrict()
        self.skills["Thrash"] = Thrash()
        self.skills["Cotton Flare"] = CottonFlare()
        self.skills["Cotton Blaze"] = CottonBlaze()
        self.skills["Wildfire"] = WildFire()
        self.skills["Silk Trick"] = SilkTrick()
        self.skills["Silk Daze"] = SilkDaze()
        self.skills["Pièce de Résistance"] = PieceDeResistance()
        self.skills["Aramid Ward"] = AramidWard()
        self.skills["Aramid Guard"] = AramidGuard()
        self.skills["Aegis' Last Stand"] = AegisLastStand()
        self.skills["Rayon Strike"] = RayonStrike()
        self.skills["Rayon Bash"] = RayonBash()
        self.skills["Kusanagi No Tsurugi"] = KusanagiNoTsurugi()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func attack(enemy: Character, skillName: String) {
        if let skill = skills[skillName]{
            var damage = skill.calculate(enemy.attribute)
            let levelMultiplier = 1.0 + (0.1 * Double(level))
            let doubleDamage = Double(damage)
            let newDamage = doubleDamage * levelMultiplier
            damage = Int(newDamage)
            enemy.currentHp -= damage
            enemy.currentHp = max(0, enemy.currentHp )
        }
    }
    
    override func skillDamage(enemy: Character, skillName: String) -> Int {
        if let skill = skills[skillName]{
            let damage = skill.calculate(enemy.attribute)
            let levelMultiplier = 1.0 + (0.1 * Double(level))
            let doubleDamage = Double(damage)
            let newDamage = doubleDamage * levelMultiplier
            return Int(newDamage)
        }else{
            fatalError()
        }
    }
    

    
    func calculateLevel(){
        let oldLevel = level
        let multiplier = Double(totalExperience)/100.0
        let newLevel = logWithBase(1.5, value: Double(multiplier))
        self.level = Int(newLevel) + 1
        // for every level increase
        for _ in (0..<self.level - oldLevel){
            // Increase HP by 20% - 25%
            maxHP += Int(Double(randomNumberBetween(20, end: 26))/100.0 * Double(maxHP))
        }
        // if level increase is to the next tens
        if (self.level % 10) - (oldLevel % 10) > 0{
            // Increase HP by 6 %
            maxHP += Int(0.06 * Double(maxHP))
        }
    }
    
    func calculateReward(enemy: Monster, mapLevel: MapLevel){
        // upgrade skills
        for skill in skills.values {
            // if skill use more than upgrade
            if skill.useCount > skill.upgradeValue{
                // if there is an upgrade skill
                if let upgradeSkill = skill.upgradedSkill{
                    // if skill not in current skills
                    if skills[upgradeSkill.init().skillName] == nil{
                        let newSkill = upgradeSkill.init()
                        skills[newSkill.skillName] = newSkill
                    }
                }
            }
        }
        // gainxp
        totalExperience += enemy.expGiven
        // getthreads
        if let newThread = enemy.threadGiven {
            
            let newSkill = newThread.init()
            skills[newSkill.skillName] = newSkill
        }
        savePlayer(mapLevel)
        

    }
    
    func savePlayer(mapLevel: MapLevel){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext

        let currentPlayer = SavePlayer.currentPlayer
        currentPlayer.maxHP = self.maxHP
        currentPlayer.totalExperience = self.totalExperience
        currentPlayer.mapLevel = mapLevel.rawValue
        
        let fetchRequest = NSFetchRequest(entityName: "PlayerSkill")
        let playerSkills: [PlayerSkill]
        do{
            playerSkills = try moc.executeFetchRequest(fetchRequest) as! [PlayerSkill]
        } catch{
            fatalError()
        }
        
        for skillName in skills.keys{
            let filteredArray = playerSkills.filter{ $0.skillName == skillName }
            
            let skill = skills[skillName]!
            let dbSkill: PlayerSkill
            if filteredArray.count > 0{
                dbSkill = filteredArray[0]
                dbSkill.useCount = skill.useCount
                dbSkill.skillName = skill.skillName
            }else{
                let dbSkill = NSEntityDescription.insertNewObjectForEntityForName("PlayerSkill", inManagedObjectContext: moc) as! PlayerSkill
                dbSkill.savePlayer = currentPlayer
                dbSkill.useCount = skill.useCount
                dbSkill.skillName = skill.skillName
            }
        }

        do {
            try moc.save()
        } catch {
            fatalError()
        }
    }
}