module File::Find;

sub find (&wanted, *@dirs) is export {
    for @dirs -> $d {
        _find(&wanted, $d);
    }
}

sub _find (&wanted, $dir) {
    my @subdirs = dir($dir);
    for @subdirs -> $s {
        next if $s eq '..' or $s eq '.';
        wanted($dir,$s);
        my $file = "$dir/$s";
        _find(&wanted, $file) if $file ~~ :d;
    }
}

