use Mojolicious::Lite;
use Mango;
use Mango::BSON ':bson';
use Mojo::Log;

# Log to STDERR
my $log = Mojo::Log->new;
$log->info('DB port info1 ' . $ENV{DB_PORT_27017_TCP_ADDR});

##kh todo: of course, change hard-code here
my $uri = 'mongodb://' . $ENV{DB_PORT_27017_TCP_ADDR}. '/test';
$log->info('DB URI: ' . $uri);
helper mango => sub { state $mango = Mango->new($uri) };


get '/' => sub {
    my $c = shift;

    $log->info('DB port info ' . $ENV{DB_PORT_27017_TCP_ADDR});

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
