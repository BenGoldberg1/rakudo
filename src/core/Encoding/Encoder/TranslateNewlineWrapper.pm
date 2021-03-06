my class Encoding::Encoder::TranslateNewlineWrapper {
    has Encoding::Encoder $!delegate;

    method new(Encoding::Encoder $delegate) {
        nqp::create(self)!setup($delegate)
    }

    method !setup(Encoding::Encoder $delegate) {
        $!delegate := $delegate;
        self
    }

    method encode-chars(Str:D $str --> Blob:D) {
        $!delegate.encode-chars(Rakudo::Internals.TRANSPOSE($str, "\n", "\r\n"))
    }
}
