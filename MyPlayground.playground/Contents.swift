import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init (name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

//TODO: Definir os erros

enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insufficientFund
    case productStuck
    case notThreeColor
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Não tem esse produto"
        case .productUnavailable:
            return "Produto indisponível"
        case .productStuck:
            return "Produto preso na máquina!"
        case .insufficientFund:
            return "Você não possui dinheiro suficiente"
        case .notThreeColor:
            return "Você não é São Paulino, então não pode"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double, clientSupports team: String) throws {
        
        //TODO: receber o dinheiro e salvar em uma variável
        
        self.money = money
        
        //TODO: achar o produto que o cliente quer
        
        let produtoOptional = estoque.first { (produto) -> Bool in 
            return produto.name == name
        }
        
        guard let produto = produtoOptional else {
            throw VendingMachineError.productNotFound
        }
        
        //TODO: ver se ainda tem esse produto
        
        guard produto.amount > 0 else {
            throw VendingMachineError.productUnavailable
        }
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        
        guard produto.price <= self.money else {
            throw VendingMachineError.insufficientFund
        }
        
        //TODO: entrega
        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
        
        // EXTRA
        
        if team.lowercased() != "são paulo" && team.lowercased() != "spfc" {
            throw VendingMachineError.notThreeColor
        }
    }
    
    func getTroco() -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        let money = self.money
        self.money = 0.0
        return money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Cookies", amount: 5, price: 10.0),
    VendingMachineProduct(name: "Chocolate", amount: 10, price: 7.0),
    VendingMachineProduct(name: "Chips", amount: 7, price: 12.0)
])

do {
    try vendingMachine.getProduct(named: "Cookies", with: 15.0, clientSupports: "São Paulo")
    print("Funcionou tricolor!")
} catch {
    print(error.localizedDescription)
}

do {
    try vendingMachine.getProduct(named: "Chips", with: 4.0, clientSupports: "SPFC")
    print("Funcionou tricolor!")
} catch {
    print(error.localizedDescription)
}

do {
    try vendingMachine.getProduct(named: "Chocolate", with: 10.0, clientSupports: "Cruzeiro")
    print("Funcionou tricolor!")
} catch {
    print(error.localizedDescription)
}


