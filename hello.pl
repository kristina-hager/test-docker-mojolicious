use Mojolicious::Lite;
use Mango;
use Mango::BSON ':bson';
use Mojo::Log;

##kh todo: of course, change hard-code here
my $uri = 'mongodb://172.17.0.7/test';
helper mango => sub { state $mango = Mango->new($uri) };

# Log to STDERR
my $log = Mojo::Log->new;

get '/' => sub {
    my $c = shift;

    ##kh todo: hardcoded collection
    $log->info('FYI connecting to DB');
    my $collection = $c->mango->db('test')->collection('people');
    my $ip = $c->tx->remote_address;

    ##todo - how to set to safe session? mango is safe by default: 
    #http://blog.kraih.com/post/43199352166/mangolicious

    ##try to insert something, not sure where I'd stick a Person struct in perl
    ##$collection->insert({data => bson_bin
    #skip insert for now, since DB should have data from the go-lang web app

    ##somehow this lookup is super delayed!
    my $doc = $collection->find_one({name => 'Ale'});
    $log->info('Looked up record in DB');

    my $ttt = 'name: ' . $doc->{name} . ' digits: ' . $doc->{phone};

#    text => 'I ♥ Mojolicious - no really!!'
    $c->render(text => 'I ♥ Mojolicious - no really!! ' . $ttt);
};

app->start;
