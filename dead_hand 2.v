`timescale 1s/1ms
// ============================================================
// dead_hand.v  (STUDENT STARTER CODE)
// BBM233 Logic Design Laboratory
// Final Project: World War III – Dead Hand Protocol
//
// IMPORTANT:
// - Do NOT change module name or port list.
// - clk is 1 Hz (1 tick per second).
// - reset is synchronous, active-high.
// - Implement Main FSM + Engagement Sub-FSM.
// ============================================================

module dead_hand(
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] threat_level,
    input  wire       diplomatic_override,
    input  wire       comms_lost,
    input  wire       system_fault,

    output reg        armed_out,
    output reg        tracking_out,
    output reg        authorization_out,
    output reg        override_ignored,
    output reg [2:0]  main_state_out,
    output reg [1:0]  sub_state_out,
    output reg [31:0] timer_out
);
//MAİN FSM STATES:
parameter peace = 3'b000 , alert = 3'b001 , mobilization = 3'b010 , engagement = 3'b011 ,
global_war = 3'b101 , deadlock = 3'b110;
// ENGAGEMENT SUB-FSM STATES:
parameter arm = 2'b00 , track = 2'b01 , authorize = 2'b10 , abort = 2'b11;
// Internal timers + state registers
reg [31:0] main_timer;// Counts time in main states
reg [31:0] sub_timer;// Counts time inside engagement states
reg [2:0] curr_main;// Current main FSM state
reg [1:0] curr_sub;// Current sub-FSM state
always @(posedge clk) begin
    // RESET BEHAVIOR:
    if (reset) begin
        curr_main <= peace;// System starts in peace
        curr_sub <= abort;// Sub-FSM starts inactive
        main_timer <= 0;
        sub_timer <= 0;
        override_ignored <= 0;
    end else begin
        timer_out <= (curr_main == engagement) ? sub_timer : main_timer;// Show correct timer depending on which FSM is active

        // Immediate jump to global war on system failure.If we are not already in a terminal state.
        if (system_fault && curr_main != deadlock && curr_main != global_war) begin
            curr_main <= global_war;
        end 
        else begin
            // If authorization phase already too far, override cannot cancel.
            if (curr_main == engagement && curr_sub == authorize && sub_timer >= 2) begin
                if (diplomatic_override) override_ignored <= 1;
            end
            // Overrides in deadlock or global war are always ignored.
            if ((curr_main == deadlock || curr_main == global_war) && diplomatic_override) begin
                override_ignored <= 1;
            end
            case (curr_main)
                // PEACE STATE:
                peace:begin
                    // If threat_level ≥ 01 for 5s, transition to ALERT.
                    if (threat_level >=  2'b01) begin
                        if (main_timer == 4) begin
                            curr_main <= alert;// Move toward alert if threat rises.
                            main_timer <= 0;
                        end else main_timer <= main_timer + 1;
                    end else main_timer <= 0;// Reset timer if no threat.
                end
                // ALERT STATE:
                alert:begin
                    //If threat_level ≥ 10 for 10s, transition to MOBILIZATION.
                    if (threat_level >= 2'b10) begin
                        if (main_timer == 9) begin
                            curr_main <= mobilization;// Move toward mobilization if threat rises.
                            main_timer <= 0;
                        end else main_timer <= main_timer + 1;
                        // If threat_level = 00 for 4s, Return to PEACE.
                    end else if (threat_level == 2'b00) begin
                        if (main_timer == 3) begin
                            curr_main <= peace;// Move toward peace if threat rises.
                            main_timer <= 0;
                        end else main_timer <= main_timer + 1;
                    end else main_timer <= 0;// Reset timer if no threat.
                end
                // MOBILIZATION STATE:
                mobilization:begin
                    // If threat_level = 11 or comms_lost = 1, transition to ENGAGEMENT.
                    if (threat_level == 2'b11 || comms_lost) begin
                        curr_main <= engagement;// Move toward engagement if threat rises.
                        // Start Engagement sub-FSM:
                        curr_sub <= arm;
                        main_timer <= 0;
                        sub_timer <= 0;
                        // If threat_level ≤ 01 for 4s, De-escalation to ALERT.
                    end else if (threat_level <= 2'b01) begin
                        if (main_timer == 3) begin
                            curr_main <= alert;// Move toward alert if threat rises.
                            main_timer <= 0;
                        end else main_timer <= main_timer + 1;
                    end else main_timer <= 0;// Reset timer if no threat.
                end
                // ENGAGEMENT STATE:
                engagement:begin
                    //If diplomatic_override=1 while Main FSM is not in DEADLOCK and not in GLOBAL_WAR, move toward abort.
                    if (diplomatic_override && curr_main != deadlock && curr_main != global_war && !(curr_sub == authorize && sub_timer >= 2)) begin
                        curr_sub <= abort;
                        sub_timer <= 0;
                    end
                    else begin
                        case (curr_sub)
                            // ARM STATE: After 4 seconds in ARM, if no diplomatic override occurs, move toward track.
                            arm:begin
                                if (sub_timer == 4) begin
                                curr_sub <= track;
                                sub_timer <= 0;
                                end else sub_timer <= sub_timer + 1;
                            end
                            //TRACK STATE:After 6 seconds in TRACK, if no diplomatic override occurs, move toward authorize.
                            track:begin
                                if (sub_timer == 6) begin
                                    curr_sub <= authorize;
                                    sub_timer <= 0;
                                end else sub_timer <= sub_timer + 1;
                            end
                            //AUTHORİZE STATE:If Sub-FSM stays in AUTHORIZE for 3 seconds, Main FSM transitions to DEADLOCK.
                            authorize:begin
                                if (sub_timer == 3) begin
                                    curr_main <= deadlock;
                                    sub_timer <= 0;
                                end else sub_timer <= sub_timer + 1;
                            end
                            //ABORT STATE:If Sub-FSM stays in ABORT for 5 seconds, Main FSM transitions back to MOBILIZATION.
                            abort:begin
                                if (sub_timer == 5) begin
                                    curr_main <= mobilization;
                                    sub_timer <= 0;
                                    main_timer <= 0;
                                end else sub_timer <= sub_timer + 1;
                            end 
                            default: ;
                        endcase
                    end 
                end
            endcase 
        end
    end   
end
always @(*)begin
    main_state_out = curr_main;// Expose main state.
    sub_state_out = (curr_main == engagement) ? curr_sub : abort;// Only meaningful in engagement.
    // Set activity outputs based on sub-state:
    armed_out = (curr_main == engagement && curr_sub == arm);
    tracking_out = (curr_main == engagement && curr_sub == track);
    authorization_out = (curr_main == engagement && curr_sub == authorize);
end
endmodule

