import os

#Factory 
class factory:
    instances = []
    #Allows you to perform the same action across all factories with the code:
        #for f in factory.instances: f.function()
    def __init__(self, code:str, dps:int, cost:int, amount=0, costrise=1.15):
        self.code=code #Used for the buy command. Must be a string because of how input() works.
        self.dps=dps #Dollars Per Second. The amount of money gained every turn by a single unit.
        self.cost=cost #Cost to upgrade the factory by 1 unit. Increased by self.upgrade().
        self.amount=amount #The number of workers. Straight multiplier for dps. Increased by self.upgrade().
        self.costrise=costrise #Amount to increase the cost after upgrade (1.0=100%=0% increase). Equation found in self.upgrade().
        self.bonus=1.0 #Currently unused. Allows for items to in(/de)crease dps.
        factory.instances.append(self)
    
    def pay(self):
        return (self.dps * self.bonus) * self.amount
    
    def upgrade(self,money):
        #Usage: money=f.upgrade(money)
        if money >= self.cost:
            money-=self.cost
            self.amount += 1
            self.cost = int(self.cost * self.costrise + self.amount)
        else:
            print("Not enough money!")
        return money
    
    def display(self):
        print(f'Income: ${self.pay()} | Amount: {self.amount} (+1 for {self.cost})')

t1=factory('1',1,10,1)
t2=factory('2',25,250)
t3=factory('3',150,1500)
money=1

while True:
    os.system('cls')

    print(f'Money: ${money}')
    for f in factory.instances: f.display()

    order=input('Buy with 1-3, skip with enter, end with "end": ')
    if order == "end": exit()
    for f in factory.instances: 
        if order == f.code: money=f.upgrade(money); break

    for f in factory.instances: money += f.pay()
    