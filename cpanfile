requires "Bubblegum" => "0.23";
requires "Exporter::Tiny" => "0";
requires "perl" => "v5.10.0";

on 'test' => sub {
  requires "perl" => "v5.10.0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};
