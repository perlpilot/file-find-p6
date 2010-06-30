module File::Find;

sub find (&wanted, *@dirs) is export {
    for @dirs -> $d {
        _find(&wanted, $d);
    }
}

# TODO Replace this with IO::Directory when available
# TODO Remove hack to turn ResizeableStringArray returned from readdir() into a Perl 6 array
sub _readdir($dir) {
    my $dirs = pir::new__PS('OS').readdir($dir);
    my @dirs;
    @dirs.push: $dirs.pop while +$dirs;
    return @dirs;
}

sub _find (&wanted, $dir) {
    my @subdirs = _readdir($dir);
    for @subdirs -> $s {
        next if $s eq '..' or $s eq '.';
        wanted($dir,$s);
        my $file = "$dir/$s";
        _find(&wanted, $file) if $file ~~ :d;
    }
}

