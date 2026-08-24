using {anubhav.cds} from '../db/CDSView';

service CDSService @(path : 'CDSService') {

entity ProductSet as projection on cds.CDSView.ProductView{
    *,
    //Please add a virtual field to show no. of times the item was bought
    virtual purchCount : Int16
};
entity ItemSet as projection on cds.CDSView.ItemView;
    

}
