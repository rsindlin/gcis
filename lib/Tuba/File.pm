=head1 NAME

Tuba::File : Controller class for files.

=cut

package Tuba::File;
use Mojo::Base qw/Tuba::Controller/;
use Tuba::DB::Objects qw/-nicknames/;

sub list {
    my $c = shift;
    return $c->render_not_found;
    $c->stash(objects => Files->get_objects(with_objects => 'publications', page => $c->page));
    my $count = Files->get_objects_count;
    $c->set_pages($count);
    $c->SUPER::list(@_);
}

sub show {
    my $c = shift;
    my $identifier = $c->stash('file_identifier');
    my $meta = File->meta;
    my $object = File->new(identifier => $identifier)->load(speculative => 1 ) or return $c->render_not_found;
    $c->respond_to(
        json => sub { shift->render(json => $c->make_tree_for_show($object)) },
        yaml  => sub { shift->render_yaml($c->make_tree_for_show($object)) },
        nt    => sub { shift->render(template => 'object',    meta => $meta, object => $object ) },
        html => sub { shift->render(template => 'file/object', meta => $meta, object => $object ) }
    );
}


1;

