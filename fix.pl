#!/usr/bin/env perl

@fields_to_include = (0,1,2,3,4,5,6,14);
@phone_fields = (11,12,13);
$entrance_field = 25;
$gender_field = 15;

while(<>) {
	next if($_ =~ m/^;;;;/);
	@fields = split /;/;
	@phones = ();
	foreach $field (@phone_fields) {
		$_phone = $fields[$field];
		@split_phones = split "/", $_phone;
		foreach $phone (@split_phones) {
			$phone =~ s/[^0-9]//g;
			$phone =~ s/^46//;
			if($phone =~ m/^[^0]/) {
				$phone = "0$phone";
			}
			if($phone =~ m/^(08|0\d{2})(.*)/) {
				$phone = $1 . "-" . $2;
			}

			if($phone =~ m/0[\d]{1,3}-\d{5,9}/) {
				push @phones, $phone;
			} else {
				print STDERR "wrong format: $phone, original: $_phone" unless $_phone == "";
			}
		}
	}
	if(scalar @phones > 1) {
		@mobile = grep(/^07/, @phones);
		@sthlm = grep(/^08/, @phones);
		@other = grep(/^0[^78]/, @phones);
		if(scalar @mobile > 0) {
			$phone = @mobile[0];
		} elsif(scalar @sthlm > 0) {
			$phone = @sthlm[0];
		} else {
			$phone = @other[0];
		}
	} else {
		$phone = @phones[0];
	}
	foreach $field (@fields_to_include) {
		print @fields[$field] . ";";
	}
	if(@fields[@phone_fields[0]] =~ m/Telefon/) {
		print "Telefon;" . $fields[$entrance_field] . ";" . $fields[$gender_field];
	} else {
		$entrance = @fields[$entrance_field] =~ m/(\d{4})-\d{2}-\d{2}/;
		$entrance = $1;
		if($entrance+0 < 2014) {
			$entrance = "older";
		}
		$gender = $fields[$gender_field];
		$gender =~ s/K/f/;
		$gender =~ s/M/m/;
		$gender =~ s/I/o/;
		print $phone . ";" . $entrance . ";" . $gender;
	}
	print "\n";
}
