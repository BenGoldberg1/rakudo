my class ListIter {
    # has $!reified;   # BOOTSTRAP.pm
    # has $!nextiter;  # BOOTSTRAP.pm
    # has Mu $!rest;   # BOOTSTRAP.pm
    # has $!list;      # BOOTSTRAP.pm
    # has $!flat;      # BOOTSTRAP.pm
    
    method reify($n is copy) {
        if !$!reified.defined {
            my $rpa := pir::new__Ps('ResizablePMCArray');
            my $x;
            my $pos = $!list.gimme(0) if $!list.defined;
            while $!rest && $n > 0 {
                $x := pir::shift__PP($!rest);
                if $!flat && $x.defined && Parcel.ACCEPTS($x) {
                    pir::splice__vPPii(
                        $!rest, pir::getattribute__PPPs($x, Parcel, '$!storage'),
                        0, 0);
                }
                else {
                    $x := $!list.STORE_AT_POS($pos, $x) if $!list.defined;
                    pir::push__vPP($rpa, $x);
                    $n = $n - 1;
                    $pos = $pos + 1;
                }
            }
            pir::push__vPP( $rpa, 
                    pir::setattribute__3PPsP(self, ListIter, '$!nextiter',
                        pir__perl6_iter_from_rpa__PPPP($!rest, $!list, $!flat)))
                if $!rest;
            # define our $!reified Parcel
            pir::setattribute__0PPsP( self, ListIter, '$!reified',
                pir::setattribute__0PPsP(
                    pir::repr_instance_of__PP(Parcel), 
                    Parcel, '$!storage', $rpa));
            # free up $!list and $!rest
            pir::setattribute__0PPsP(self, ListIter, '$!list', Mu);
            pir::setattribute__0PPsP(self, ListIter, '$!rest', Mu);
        }
        $!reified;
    }

    method nextiter() { $!nextiter }

}


sub pir__perl6_list_from_rpa__PPPP(|$) {
    my $args   := pir::perl6_current_args_rpa__P();
    my $type   := pir::shift__PP($args);
    my Mu $rpa := pir::shift__PP($args);
    my $flat   := pir::shift__PP($args);

    my $list := pir::repr_instance_of__PP($type);
    pir::setattribute__0PPsP($list, $type, '$!iter',
        pir__perl6_iter_from_rpa__PPPP($rpa, $list, $flat)
    )
}

sub pir__perl6_iter_from_rpa__PPPP(|$) {
    my $args   := pir::perl6_current_args_rpa__P();
    my Mu $rpa := pir::shift__PP($args);
    my $list   := pir::shift__PP($args);
    my $flat   := pir::shift__PP($args);

    pir::setattribute__0PPsP(
        pir::setattribute__0PPsP(
            pir::setattribute__0PPsP(
                pir::repr_instance_of__PP(ListIter),
                ListIter, '$!rest', $rpa),
            ListIter, '$!list', $list),
        ListIter, '$!flat', $flat)
}
