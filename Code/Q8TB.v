module Q8TB;

reg car_entered, is_uni_car_entered, car_exited, is_uni_car_exited;
reg [4:0] hour;
wire [8:0] uni_parked_car, parked_car, uni_vacated_space, vacated_space;
wire uni_is_vacated_space, is_vacated_space;

parking p(
    car_entered, is_uni_car_entered, car_exited, is_uni_car_exited,
    hour,
    uni_parked_car, parked_car, uni_vacated_space, vacated_space,
    uni_is_vacated_space, is_vacated_space);

initial begin
    car_entered = 0;
    is_uni_car_entered = 0;
    car_exited = 0;
    is_uni_car_exited = 0;
end

initial begin
  forever begin
    car_entered = (($time % (16*60)) <= (5*60)) ||
                  (($time % (16*60)) >= (8.5*60) && ($time % (16*60)) <= (10*60)) ||
                  (($time % (16*60)) >= (12.5*60) && ($time % (16*60)) < (15*60));

    car_exited = (($time % (16*60)) > (5*60) && ($time % (16*60)) < (8.5*60)) ||
                 (($time % (16*60)) > (10*60) && ($time % (16*60)) < (12.5*60)) ||
                 (($time % (16*60)) >= (15*60));
    // car_entered = ($time <= (14*60));
    // car_exited = ($time > (14*60));
    // is_uni_car_entered = 1;
    is_uni_car_entered = $urandom_range(0, 1);
    is_uni_car_exited = $urandom_range(0, 1);
    hour = (8 + $time/60) % 24;
    #1;
    car_entered = 0;
    car_exited = 0;
    #2 $display ("Time = %02d:%02d\nuni_parked_car =  %d, parked_car =  %d\nuni_vacated_space =  %d, vacated_space = %d\nuni_is_vacated_space = %d, is_vacated_space = %d\n", (8 + ($time/60))%24, $time % 60, uni_parked_car, parked_car, uni_vacated_space, vacated_space, uni_is_vacated_space, is_vacated_space);
    if ($time > (16*60))
      $stop();
  end
end

endmodule
