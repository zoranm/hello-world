community OilPurchase {
    objective "Efficient ordering of oil"
    roles customer, supplier, producer, carrier
}

events {
    oilDelivered, paymentMade
}

 # deontic tokens encapsulate obligations (burden), 
 # permissions (permits) and prohibitions (embargos)

 # speech act -> creates and deletes deontic tokens (can be for multiple partes)

 # parties holding the tokens act to satisfy deontic constraints
 # when parties discharge obligations, deontic tokens are deleted
 
 # deontic tokens can include a reference to the party on 'other side' 
 # of normative relation (target), e.g. customer provides permit to supplier

 # behaviour can include temporal constraint, such as 'pay within 7 days to supplier' 
 # this below is just a placeholder for discussing life cycle of deontic toke
 # how do we link its life cycle with the actions of roles ?

 # notation asssumption
 # each deontik token is activated by an action of a party, which may 
 # inderectly represented as an event observed by the burden subject

# notation for decribing life cycle of deontic tokens   
#   deonticToken  activation -> expectedAction(subject, [target],[artifacts]), 
#       de-activation -> done 
# holder of deontic token (subject) perfoms action (actor) effecting (target) party 
# nominates condition (event) when obligation is discharged ('done')
# done signifies deontic doken in question deletion 
# 

deonticToken {
# deontic token life cycle: event -> state 
# create or delegate caused by action performance
    create      ->  active          # action of the agent or event trigger 
    delegate    ->  pending         # delegate action
    done        ->  destructed 
    subject         party 
    target          party 
    behaviour       rule 
}

# artifacts - objects referenced by actions

artifact Oil-PO {
    price       int 
    quantity    int 
}

artifact CreditCard {
    name        string
    number      string 
}

artifact carrierContract {
    parties supplier, carrier
}

artifact providerContract {
    parties supplier, provider
}

artifact Oil-package {
    carrier       party 
    time          string 
}

role customer {
    # order is a speech act as it creates two burdens and one permit next 
    action order {              
        # burden  - for supplier to deliver Oil per Oil-PO
        burden      this -> acceptOrder(supplier, Oil-PO) -> oilDelivered  
        # burden  - for customer to pay upon oilDelivered event
        burden      oilDelivered -> payment(self, CreditCard) ->  paymentMade
        # per the paper: when payment by CC customet gives the supplier
        # permission to take the required payment (i.e. charge action)
        permit      oilDelivered -> charge(supplier, CreditCard) -> paymentMade         
   }
}

role supplier {
    action acceptOrder {
    #oilDeleivered discharges supplier obligation (done) 
    #   burden      this -> delivery(self,Oil-PO), oilDelivered -> done
        burden      this -> self.delivery([target], Oil-PO) -> oilDelivered 
    
    #action instructProducer  {
    #    burden      this-> delivery.delegated (producer,Oil-PO), oilDelivered -> done   
    #action instructCarrier {
    #    burden      this -> delivery.delegated(carrier, carrierOil-PO), oilDelivered -> done 
    #} 

    action delivery {
        burden      this->  delivery (producer,Oil-PO), oilDelivered -> done  
        burden      this -> delivery (carrier, carrierOil-PO), oilDelivered -> done 
    }
    
    action monitorDelivery {
        burden      this -> monitor (self, oilDelivered)
    }
    action payProvider {
        burden      oilDelivered -> pay(self, provider, providerContract)
    }
    action payCarrier {
        burden      oilDelivered -> pay(self, carrier, carrierContract)
    }
}

role producer {
    action         accept.instruct
    burden         this->prepareForPickup(self, Oil-PO) -> 
}

# best wasy to desctibe deletion of deontik token from Active -> Deleted
# how to link action and events? Some similarity with State Machine?

role carrier {
    action         accept.instruct 
    burden         this -> pickup (self, Oil-PO)
}

# ZM comment: think whether we need to explicitly deal with interaction modelling concept

