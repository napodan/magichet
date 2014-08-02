use strict;
use warnings;

$mod_two = pop(@ARGV);
$mod_one = pop(@ARGV);

sub get_item_name {
	my ($full_string);
	($full_string) = @_;
	@item_names = ($full_string =~ /$mod_two:(\w*)?/g);
	return @item_names;
}

sub uniques {
	my (%uniques,$var);
	foreach $var (@_) {
		$uniques{"$var"} = $var;
	}
	return %uniques;
}

@output = ();
foreach $input (<>){
	foreach $name (&get_item_name($input)) {
		push(@output,"$name");
	}
}

%u = &uniques(@output);
foreach $key (keys %u) {
	print("minetest.register_alias(\"$mod_one:$u{$key}\",\"$mod_two:$u{$key}\")\n");
}
