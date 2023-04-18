// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Verifier {
    function verify(
        uint256[] memory pubInputs,
        bytes memory proof
    ) public view returns (bool) {
        bool success = true;
        bytes32[1028] memory transcript;
        assembly {
            let
                f_p
            := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let
                f_q
            := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
            function validate_ec_point(x, y) -> valid {
                {
                    let x_lt_p := lt(
                        x,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    let y_lt_p := lt(
                        y,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    valid := and(x_lt_p, y_lt_p)
                }
                {
                    let x_is_zero := eq(x, 0)
                    let y_is_zero := eq(y, 0)
                    let x_or_y_is_zero := or(x_is_zero, y_is_zero)
                    let x_and_y_is_not_zero := not(x_or_y_is_zero)
                    valid := and(x_and_y_is_not_zero, valid)
                }
                {
                    let y_square := mulmod(
                        y,
                        y,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    let x_square := mulmod(
                        x,
                        x,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    let x_cube := mulmod(
                        x_square,
                        x,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    let x_cube_plus_3 := addmod(
                        x_cube,
                        3,
                        0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                    )
                    let y_square_eq_x_cube_plus_3 := eq(x_cube_plus_3, y_square)
                    valid := and(y_square_eq_x_cube_plus_3, valid)
                }
            }
            mstore(add(transcript, 0x20), mod(mload(add(pubInputs, 0x20)), f_q))
            mstore(add(transcript, 0x40), mod(mload(add(pubInputs, 0x40)), f_q))
            mstore(add(transcript, 0x60), mod(mload(add(pubInputs, 0x60)), f_q))
            mstore(add(transcript, 0x80), mod(mload(add(pubInputs, 0x80)), f_q))
            mstore(add(transcript, 0xa0), mod(mload(add(pubInputs, 0xa0)), f_q))
            mstore(add(transcript, 0xc0), mod(mload(add(pubInputs, 0xc0)), f_q))
            mstore(add(transcript, 0xe0), mod(mload(add(pubInputs, 0xe0)), f_q))
            mstore(
                add(transcript, 0x100),
                mod(mload(add(pubInputs, 0x100)), f_q)
            )
            mstore(
                add(transcript, 0x120),
                mod(mload(add(pubInputs, 0x120)), f_q)
            )
            mstore(
                add(transcript, 0x140),
                mod(mload(add(pubInputs, 0x140)), f_q)
            )
            mstore(
                add(transcript, 0x160),
                mod(mload(add(pubInputs, 0x160)), f_q)
            )
            mstore(
                add(transcript, 0x180),
                mod(mload(add(pubInputs, 0x180)), f_q)
            )
            mstore(
                add(transcript, 0x1a0),
                mod(mload(add(pubInputs, 0x1a0)), f_q)
            )
            mstore(
                add(transcript, 0x1c0),
                mod(mload(add(pubInputs, 0x1c0)), f_q)
            )
            mstore(
                add(transcript, 0x0),
                12608146338953113158460390076610745144881221521673491110401327735882547413400
            )
            {
                let x := mload(add(proof, 0x20))
                mstore(add(transcript, 0x1e0), x)
                let y := mload(add(proof, 0x40))
                mstore(add(transcript, 0x200), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x60))
                mstore(add(transcript, 0x220), x)
                let y := mload(add(proof, 0x80))
                mstore(add(transcript, 0x240), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xa0))
                mstore(add(transcript, 0x260), x)
                let y := mload(add(proof, 0xc0))
                mstore(add(transcript, 0x280), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xe0))
                mstore(add(transcript, 0x2a0), x)
                let y := mload(add(proof, 0x100))
                mstore(add(transcript, 0x2c0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x120))
                mstore(add(transcript, 0x2e0), x)
                let y := mload(add(proof, 0x140))
                mstore(add(transcript, 0x300), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x160))
                mstore(add(transcript, 0x320), x)
                let y := mload(add(proof, 0x180))
                mstore(add(transcript, 0x340), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(add(transcript, 0x360), keccak256(add(transcript, 0x0), 864))
            {
                let hash := mload(add(transcript, 0x360))
                mstore(add(transcript, 0x380), mod(hash, f_q))
                mstore(add(transcript, 0x3a0), hash)
            }
            {
                let x := mload(add(proof, 0x1a0))
                mstore(add(transcript, 0x3c0), x)
                let y := mload(add(proof, 0x1c0))
                mstore(add(transcript, 0x3e0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x1e0))
                mstore(add(transcript, 0x400), x)
                let y := mload(add(proof, 0x200))
                mstore(add(transcript, 0x420), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x440),
                keccak256(add(transcript, 0x3a0), 160)
            )
            {
                let hash := mload(add(transcript, 0x440))
                mstore(add(transcript, 0x460), mod(hash, f_q))
                mstore(add(transcript, 0x480), hash)
            }
            mstore8(add(transcript, 0x4a0), 1)
            mstore(
                add(transcript, 0x4a0),
                keccak256(add(transcript, 0x480), 33)
            )
            {
                let hash := mload(add(transcript, 0x4a0))
                mstore(add(transcript, 0x4c0), mod(hash, f_q))
                mstore(add(transcript, 0x4e0), hash)
            }
            {
                let x := mload(add(proof, 0x220))
                mstore(add(transcript, 0x500), x)
                let y := mload(add(proof, 0x240))
                mstore(add(transcript, 0x520), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x260))
                mstore(add(transcript, 0x540), x)
                let y := mload(add(proof, 0x280))
                mstore(add(transcript, 0x560), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x2a0))
                mstore(add(transcript, 0x580), x)
                let y := mload(add(proof, 0x2c0))
                mstore(add(transcript, 0x5a0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x2e0))
                mstore(add(transcript, 0x5c0), x)
                let y := mload(add(proof, 0x300))
                mstore(add(transcript, 0x5e0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x320))
                mstore(add(transcript, 0x600), x)
                let y := mload(add(proof, 0x340))
                mstore(add(transcript, 0x620), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x360))
                mstore(add(transcript, 0x640), x)
                let y := mload(add(proof, 0x380))
                mstore(add(transcript, 0x660), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x680),
                keccak256(add(transcript, 0x4e0), 416)
            )
            {
                let hash := mload(add(transcript, 0x680))
                mstore(add(transcript, 0x6a0), mod(hash, f_q))
                mstore(add(transcript, 0x6c0), hash)
            }
            {
                let x := mload(add(proof, 0x3a0))
                mstore(add(transcript, 0x6e0), x)
                let y := mload(add(proof, 0x3c0))
                mstore(add(transcript, 0x700), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x3e0))
                mstore(add(transcript, 0x720), x)
                let y := mload(add(proof, 0x400))
                mstore(add(transcript, 0x740), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x420))
                mstore(add(transcript, 0x760), x)
                let y := mload(add(proof, 0x440))
                mstore(add(transcript, 0x780), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x7a0),
                keccak256(add(transcript, 0x6c0), 224)
            )
            {
                let hash := mload(add(transcript, 0x7a0))
                mstore(add(transcript, 0x7c0), mod(hash, f_q))
                mstore(add(transcript, 0x7e0), hash)
            }
            mstore(add(transcript, 0x800), mod(mload(add(proof, 0x460)), f_q))
            mstore(add(transcript, 0x820), mod(mload(add(proof, 0x480)), f_q))
            mstore(add(transcript, 0x840), mod(mload(add(proof, 0x4a0)), f_q))
            mstore(add(transcript, 0x860), mod(mload(add(proof, 0x4c0)), f_q))
            mstore(add(transcript, 0x880), mod(mload(add(proof, 0x4e0)), f_q))
            mstore(add(transcript, 0x8a0), mod(mload(add(proof, 0x500)), f_q))
            mstore(add(transcript, 0x8c0), mod(mload(add(proof, 0x520)), f_q))
            mstore(add(transcript, 0x8e0), mod(mload(add(proof, 0x540)), f_q))
            mstore(add(transcript, 0x900), mod(mload(add(proof, 0x560)), f_q))
            mstore(add(transcript, 0x920), mod(mload(add(proof, 0x580)), f_q))
            mstore(add(transcript, 0x940), mod(mload(add(proof, 0x5a0)), f_q))
            mstore(add(transcript, 0x960), mod(mload(add(proof, 0x5c0)), f_q))
            mstore(add(transcript, 0x980), mod(mload(add(proof, 0x5e0)), f_q))
            mstore(add(transcript, 0x9a0), mod(mload(add(proof, 0x600)), f_q))
            mstore(add(transcript, 0x9c0), mod(mload(add(proof, 0x620)), f_q))
            mstore(add(transcript, 0x9e0), mod(mload(add(proof, 0x640)), f_q))
            mstore(add(transcript, 0xa00), mod(mload(add(proof, 0x660)), f_q))
            mstore(add(transcript, 0xa20), mod(mload(add(proof, 0x680)), f_q))
            mstore(add(transcript, 0xa40), mod(mload(add(proof, 0x6a0)), f_q))
            mstore(add(transcript, 0xa60), mod(mload(add(proof, 0x6c0)), f_q))
            mstore(add(transcript, 0xa80), mod(mload(add(proof, 0x6e0)), f_q))
            mstore(add(transcript, 0xaa0), mod(mload(add(proof, 0x700)), f_q))
            mstore(add(transcript, 0xac0), mod(mload(add(proof, 0x720)), f_q))
            mstore(add(transcript, 0xae0), mod(mload(add(proof, 0x740)), f_q))
            mstore(add(transcript, 0xb00), mod(mload(add(proof, 0x760)), f_q))
            mstore(add(transcript, 0xb20), mod(mload(add(proof, 0x780)), f_q))
            mstore(add(transcript, 0xb40), mod(mload(add(proof, 0x7a0)), f_q))
            mstore(add(transcript, 0xb60), mod(mload(add(proof, 0x7c0)), f_q))
            mstore(add(transcript, 0xb80), mod(mload(add(proof, 0x7e0)), f_q))
            mstore(add(transcript, 0xba0), mod(mload(add(proof, 0x800)), f_q))
            mstore(add(transcript, 0xbc0), mod(mload(add(proof, 0x820)), f_q))
            mstore(add(transcript, 0xbe0), mod(mload(add(proof, 0x840)), f_q))
            mstore(add(transcript, 0xc00), mod(mload(add(proof, 0x860)), f_q))
            mstore(add(transcript, 0xc20), mod(mload(add(proof, 0x880)), f_q))
            mstore(add(transcript, 0xc40), mod(mload(add(proof, 0x8a0)), f_q))
            mstore(add(transcript, 0xc60), mod(mload(add(proof, 0x8c0)), f_q))
            mstore(add(transcript, 0xc80), mod(mload(add(proof, 0x8e0)), f_q))
            mstore(add(transcript, 0xca0), mod(mload(add(proof, 0x900)), f_q))
            mstore(add(transcript, 0xcc0), mod(mload(add(proof, 0x920)), f_q))
            mstore(add(transcript, 0xce0), mod(mload(add(proof, 0x940)), f_q))
            mstore(add(transcript, 0xd00), mod(mload(add(proof, 0x960)), f_q))
            mstore(add(transcript, 0xd20), mod(mload(add(proof, 0x980)), f_q))
            mstore(add(transcript, 0xd40), mod(mload(add(proof, 0x9a0)), f_q))
            mstore(add(transcript, 0xd60), mod(mload(add(proof, 0x9c0)), f_q))
            mstore(add(transcript, 0xd80), mod(mload(add(proof, 0x9e0)), f_q))
            mstore(add(transcript, 0xda0), mod(mload(add(proof, 0xa00)), f_q))
            mstore(add(transcript, 0xdc0), mod(mload(add(proof, 0xa20)), f_q))
            mstore(add(transcript, 0xde0), mod(mload(add(proof, 0xa40)), f_q))
            mstore(add(transcript, 0xe00), mod(mload(add(proof, 0xa60)), f_q))
            mstore(add(transcript, 0xe20), mod(mload(add(proof, 0xa80)), f_q))
            mstore(add(transcript, 0xe40), mod(mload(add(proof, 0xaa0)), f_q))
            mstore(
                add(transcript, 0xe60),
                keccak256(add(transcript, 0x7e0), 1664)
            )
            {
                let hash := mload(add(transcript, 0xe60))
                mstore(add(transcript, 0xe80), mod(hash, f_q))
                mstore(add(transcript, 0xea0), hash)
            }
            {
                let x := mload(add(proof, 0xac0))
                mstore(add(transcript, 0xec0), x)
                let y := mload(add(proof, 0xae0))
                mstore(add(transcript, 0xee0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xb00))
                mstore(add(transcript, 0xf00), x)
                let y := mload(add(proof, 0xb20))
                mstore(add(transcript, 0xf20), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xb40))
                mstore(add(transcript, 0xf40), x)
                let y := mload(add(proof, 0xb60))
                mstore(add(transcript, 0xf60), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xb80))
                mstore(add(transcript, 0xf80), x)
                let y := mload(add(proof, 0xba0))
                mstore(add(transcript, 0xfa0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xbc0))
                mstore(add(transcript, 0xfc0), x)
                let y := mload(add(proof, 0xbe0))
                mstore(add(transcript, 0xfe0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xc00))
                mstore(add(transcript, 0x1000), x)
                let y := mload(add(proof, 0xc20))
                mstore(add(transcript, 0x1020), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x1040),
                keccak256(add(transcript, 0xea0), 416)
            )
            {
                let hash := mload(add(transcript, 0x1040))
                mstore(add(transcript, 0x1060), mod(hash, f_q))
                mstore(add(transcript, 0x1080), hash)
            }
            {
                let x := mload(add(transcript, 0x20))
                x := add(x, shl(88, mload(add(transcript, 0x40))))
                x := add(x, shl(176, mload(add(transcript, 0x60))))
                mstore(add(transcript, 0x10a0), x)
                let y := mload(add(transcript, 0x80))
                y := add(y, shl(88, mload(add(transcript, 0xa0))))
                y := add(y, shl(176, mload(add(transcript, 0xc0))))
                mstore(add(transcript, 0x10c0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(transcript, 0xe0))
                x := add(x, shl(88, mload(add(transcript, 0x100))))
                x := add(x, shl(176, mload(add(transcript, 0x120))))
                mstore(add(transcript, 0x10e0), x)
                let y := mload(add(transcript, 0x140))
                y := add(y, shl(88, mload(add(transcript, 0x160))))
                y := add(y, shl(176, mload(add(transcript, 0x180))))
                mstore(add(transcript, 0x1100), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x1120),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1140),
                mulmod(
                    mload(add(transcript, 0x1120)),
                    mload(add(transcript, 0x1120)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1160),
                mulmod(
                    mload(add(transcript, 0x1140)),
                    mload(add(transcript, 0x1140)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1180),
                mulmod(
                    mload(add(transcript, 0x1160)),
                    mload(add(transcript, 0x1160)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11a0),
                mulmod(
                    mload(add(transcript, 0x1180)),
                    mload(add(transcript, 0x1180)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11c0),
                mulmod(
                    mload(add(transcript, 0x11a0)),
                    mload(add(transcript, 0x11a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11e0),
                mulmod(
                    mload(add(transcript, 0x11c0)),
                    mload(add(transcript, 0x11c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1200),
                mulmod(
                    mload(add(transcript, 0x11e0)),
                    mload(add(transcript, 0x11e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1220),
                mulmod(
                    mload(add(transcript, 0x1200)),
                    mload(add(transcript, 0x1200)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1240),
                mulmod(
                    mload(add(transcript, 0x1220)),
                    mload(add(transcript, 0x1220)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1260),
                mulmod(
                    mload(add(transcript, 0x1240)),
                    mload(add(transcript, 0x1240)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1280),
                mulmod(
                    mload(add(transcript, 0x1260)),
                    mload(add(transcript, 0x1260)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12a0),
                mulmod(
                    mload(add(transcript, 0x1280)),
                    mload(add(transcript, 0x1280)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12c0),
                mulmod(
                    mload(add(transcript, 0x12a0)),
                    mload(add(transcript, 0x12a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12e0),
                mulmod(
                    mload(add(transcript, 0x12c0)),
                    mload(add(transcript, 0x12c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1300),
                mulmod(
                    mload(add(transcript, 0x12e0)),
                    mload(add(transcript, 0x12e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1320),
                mulmod(
                    mload(add(transcript, 0x1300)),
                    mload(add(transcript, 0x1300)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1340),
                mulmod(
                    mload(add(transcript, 0x1320)),
                    mload(add(transcript, 0x1320)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1360),
                mulmod(
                    mload(add(transcript, 0x1340)),
                    mload(add(transcript, 0x1340)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1380),
                mulmod(
                    mload(add(transcript, 0x1360)),
                    mload(add(transcript, 0x1360)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13a0),
                mulmod(
                    mload(add(transcript, 0x1380)),
                    mload(add(transcript, 0x1380)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13c0),
                mulmod(
                    mload(add(transcript, 0x13a0)),
                    mload(add(transcript, 0x13a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13e0),
                mulmod(
                    mload(add(transcript, 0x13c0)),
                    mload(add(transcript, 0x13c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1400),
                mulmod(
                    mload(add(transcript, 0x13e0)),
                    mload(add(transcript, 0x13e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1420),
                addmod(
                    mload(add(transcript, 0x1400)),
                    21888242871839275222246405745257275088548364400416034343698204186575808495616,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1440),
                mulmod(
                    mload(add(transcript, 0x1420)),
                    21888241567198334088790460357988866238279339518792980768180410072331574733841,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1460),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    12929131318670223636853686797196826072950305380535537217467769528748593133487,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1480),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    8959111553169051585392718948060449015598059019880497126230434657827215362130,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14a0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    14655294445420895451632927078981340937842238432098198055057679026789553137428,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14c0),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    7232948426418379770613478666275934150706125968317836288640525159786255358189,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14e0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    12220484078924208264862893648548198807365556694478604924193442790112568454894,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1500),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    9667758792915066957383512096709076281182807705937429419504761396463240040723,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1520),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    8734126352828345679573237859165904705806588461301144420590422589042130041188,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1540),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    13154116519010929542673167886091370382741775939114889923107781597533678454429,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1560),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    7358966525675286471217089135633860168646304224547606326237275077574224349359,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1580),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    14529276346163988751029316609623414919902060175868428017460929109001584146258,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15a0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    9741553891420464328295280489650144566903017206473301385034033384879943874347,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15c0),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    12146688980418810893951125255607130521645347193942732958664170801695864621270,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15e0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    17329448237240114492580865744088056414251735686965494637158808787419781175510,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1600),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    4558794634599160729665540001169218674296628713450539706539395399156027320107,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1620),
                mulmod(mload(add(transcript, 0x1440)), 1, f_q)
            )
            mstore(
                add(transcript, 0x1640),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    21888242871839275222246405745257275088548364400416034343698204186575808495616,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1660),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    11451405578697956743456240853980216273390554734748796433026540431386972584651,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1680),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    10436837293141318478790164891277058815157809665667237910671663755188835910966,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x16a0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    8374374965308410102411073611984011876711565317741801500439755773472076597347,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x16c0),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    13513867906530865119835332133273263211836799082674232843258448413103731898270,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x16e0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    21490807004895109926141140246143262403290679459142140821740925192625185504522,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1700),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    397435866944165296105265499114012685257684941273893521957278993950622991095,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1720),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    11211301017135681023579411905410872569206244553457844956874280139879520583390,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1740),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    10676941854703594198666993839846402519342119846958189386823924046696287912227,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1760),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    18846108080730935585192484934247867403156699586319724728525857970312957475341,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1780),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    3042134791108339637053920811009407685391664814096309615172346216262851020276,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x17a0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    3615478808282855240548287271348143516886772452944084747768312988864436725401,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x17c0),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    18272764063556419981698118473909131571661591947471949595929891197711371770216,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x17e0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    21451937155080765789602997556105366785934335730087568134349216848800867145453,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1800),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    436305716758509432643408189151908302614028670328466209348987337774941350164,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1820),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    1426404432721484388505361748317961535523355871255605456897797744433766488507,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1840),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    20461838439117790833741043996939313553025008529160428886800406442142042007110,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1860),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    13982290267294411190096162596630216412723378687553046594730793425118513274800,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1880),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    7905952604544864032150243148627058675824985712862987748967410761457295220817,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x18a0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    216092043779272773661818549620449970334216366264741118684015851799902419467,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x18c0),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    21672150828060002448584587195636825118214148034151293225014188334775906076150,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x18e0),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    9537783784440837896026284659246718978615447564543116209283382057778110278482,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1900),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    12350459087398437326220121086010556109932916835872918134414822128797698217135,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1920),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    12619617507853212586156872920672483948819476989779550311307282715684870266992,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1940),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    9268625363986062636089532824584791139728887410636484032390921470890938228625,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1960),
                mulmod(
                    mload(add(transcript, 0x1440)),
                    3947443723575973965644279767310964219908423994086470065513888332899718123222,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1980),
                addmod(
                    mload(add(transcript, 0x7c0)),
                    17940799148263301256602125977946310868639940406329564278184315853676090372395,
                    f_q
                )
            )
            {
                let prod := mload(add(transcript, 0x1480))
                prod := mulmod(mload(add(transcript, 0x14c0)), prod, f_q)
                mstore(add(transcript, 0x19a0), prod)
                prod := mulmod(mload(add(transcript, 0x1500)), prod, f_q)
                mstore(add(transcript, 0x19c0), prod)
                prod := mulmod(mload(add(transcript, 0x1540)), prod, f_q)
                mstore(add(transcript, 0x19e0), prod)
                prod := mulmod(mload(add(transcript, 0x1580)), prod, f_q)
                mstore(add(transcript, 0x1a00), prod)
                prod := mulmod(mload(add(transcript, 0x15c0)), prod, f_q)
                mstore(add(transcript, 0x1a20), prod)
                prod := mulmod(mload(add(transcript, 0x1600)), prod, f_q)
                mstore(add(transcript, 0x1a40), prod)
                prod := mulmod(mload(add(transcript, 0x1640)), prod, f_q)
                mstore(add(transcript, 0x1a60), prod)
                prod := mulmod(mload(add(transcript, 0x1680)), prod, f_q)
                mstore(add(transcript, 0x1a80), prod)
                prod := mulmod(mload(add(transcript, 0x16c0)), prod, f_q)
                mstore(add(transcript, 0x1aa0), prod)
                prod := mulmod(mload(add(transcript, 0x1700)), prod, f_q)
                mstore(add(transcript, 0x1ac0), prod)
                prod := mulmod(mload(add(transcript, 0x1740)), prod, f_q)
                mstore(add(transcript, 0x1ae0), prod)
                prod := mulmod(mload(add(transcript, 0x1780)), prod, f_q)
                mstore(add(transcript, 0x1b00), prod)
                prod := mulmod(mload(add(transcript, 0x17c0)), prod, f_q)
                mstore(add(transcript, 0x1b20), prod)
                prod := mulmod(mload(add(transcript, 0x1800)), prod, f_q)
                mstore(add(transcript, 0x1b40), prod)
                prod := mulmod(mload(add(transcript, 0x1840)), prod, f_q)
                mstore(add(transcript, 0x1b60), prod)
                prod := mulmod(mload(add(transcript, 0x1880)), prod, f_q)
                mstore(add(transcript, 0x1b80), prod)
                prod := mulmod(mload(add(transcript, 0x18c0)), prod, f_q)
                mstore(add(transcript, 0x1ba0), prod)
                prod := mulmod(mload(add(transcript, 0x1900)), prod, f_q)
                mstore(add(transcript, 0x1bc0), prod)
                prod := mulmod(mload(add(transcript, 0x1940)), prod, f_q)
                mstore(add(transcript, 0x1be0), prod)
                prod := mulmod(mload(add(transcript, 0x1980)), prod, f_q)
                mstore(add(transcript, 0x1c00), prod)
                prod := mulmod(mload(add(transcript, 0x1420)), prod, f_q)
                mstore(add(transcript, 0x1c20), prod)
            }
            mstore(add(transcript, 0x1c60), 32)
            mstore(add(transcript, 0x1c80), 32)
            mstore(add(transcript, 0x1ca0), 32)
            mstore(add(transcript, 0x1cc0), mload(add(transcript, 0x1c20)))
            mstore(
                add(transcript, 0x1ce0),
                21888242871839275222246405745257275088548364400416034343698204186575808495615
            )
            mstore(
                add(transcript, 0x1d00),
                21888242871839275222246405745257275088548364400416034343698204186575808495617
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x5,
                        add(transcript, 0x1c60),
                        0xc0,
                        add(transcript, 0x1c40),
                        0x20
                    ),
                    1
                ),
                success
            )
            {
                let inv := mload(add(transcript, 0x1c40))
                let v
                v := mload(add(transcript, 0x1420))
                mstore(
                    add(transcript, 0x1420),
                    mulmod(mload(add(transcript, 0x1c00)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1980))
                mstore(
                    add(transcript, 0x1980),
                    mulmod(mload(add(transcript, 0x1be0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1940))
                mstore(
                    add(transcript, 0x1940),
                    mulmod(mload(add(transcript, 0x1bc0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1900))
                mstore(
                    add(transcript, 0x1900),
                    mulmod(mload(add(transcript, 0x1ba0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x18c0))
                mstore(
                    add(transcript, 0x18c0),
                    mulmod(mload(add(transcript, 0x1b80)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1880))
                mstore(
                    add(transcript, 0x1880),
                    mulmod(mload(add(transcript, 0x1b60)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1840))
                mstore(
                    add(transcript, 0x1840),
                    mulmod(mload(add(transcript, 0x1b40)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1800))
                mstore(
                    add(transcript, 0x1800),
                    mulmod(mload(add(transcript, 0x1b20)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x17c0))
                mstore(
                    add(transcript, 0x17c0),
                    mulmod(mload(add(transcript, 0x1b00)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1780))
                mstore(
                    add(transcript, 0x1780),
                    mulmod(mload(add(transcript, 0x1ae0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1740))
                mstore(
                    add(transcript, 0x1740),
                    mulmod(mload(add(transcript, 0x1ac0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1700))
                mstore(
                    add(transcript, 0x1700),
                    mulmod(mload(add(transcript, 0x1aa0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x16c0))
                mstore(
                    add(transcript, 0x16c0),
                    mulmod(mload(add(transcript, 0x1a80)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1680))
                mstore(
                    add(transcript, 0x1680),
                    mulmod(mload(add(transcript, 0x1a60)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1640))
                mstore(
                    add(transcript, 0x1640),
                    mulmod(mload(add(transcript, 0x1a40)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1600))
                mstore(
                    add(transcript, 0x1600),
                    mulmod(mload(add(transcript, 0x1a20)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x15c0))
                mstore(
                    add(transcript, 0x15c0),
                    mulmod(mload(add(transcript, 0x1a00)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1580))
                mstore(
                    add(transcript, 0x1580),
                    mulmod(mload(add(transcript, 0x19e0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1540))
                mstore(
                    add(transcript, 0x1540),
                    mulmod(mload(add(transcript, 0x19c0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1500))
                mstore(
                    add(transcript, 0x1500),
                    mulmod(mload(add(transcript, 0x19a0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x14c0))
                mstore(
                    add(transcript, 0x14c0),
                    mulmod(mload(add(transcript, 0x1480)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                mstore(add(transcript, 0x1480), inv)
            }
            mstore(
                add(transcript, 0x1d20),
                mulmod(
                    mload(add(transcript, 0x1460)),
                    mload(add(transcript, 0x1480)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d40),
                mulmod(
                    mload(add(transcript, 0x14a0)),
                    mload(add(transcript, 0x14c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d60),
                mulmod(
                    mload(add(transcript, 0x14e0)),
                    mload(add(transcript, 0x1500)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d80),
                mulmod(
                    mload(add(transcript, 0x1520)),
                    mload(add(transcript, 0x1540)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1da0),
                mulmod(
                    mload(add(transcript, 0x1560)),
                    mload(add(transcript, 0x1580)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1dc0),
                mulmod(
                    mload(add(transcript, 0x15a0)),
                    mload(add(transcript, 0x15c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1de0),
                mulmod(
                    mload(add(transcript, 0x15e0)),
                    mload(add(transcript, 0x1600)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e00),
                mulmod(
                    mload(add(transcript, 0x1620)),
                    mload(add(transcript, 0x1640)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e20),
                mulmod(
                    mload(add(transcript, 0x1660)),
                    mload(add(transcript, 0x1680)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e40),
                mulmod(
                    mload(add(transcript, 0x16a0)),
                    mload(add(transcript, 0x16c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e60),
                mulmod(
                    mload(add(transcript, 0x16e0)),
                    mload(add(transcript, 0x1700)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e80),
                mulmod(
                    mload(add(transcript, 0x1720)),
                    mload(add(transcript, 0x1740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ea0),
                mulmod(
                    mload(add(transcript, 0x1760)),
                    mload(add(transcript, 0x1780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ec0),
                mulmod(
                    mload(add(transcript, 0x17a0)),
                    mload(add(transcript, 0x17c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ee0),
                mulmod(
                    mload(add(transcript, 0x17e0)),
                    mload(add(transcript, 0x1800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f00),
                mulmod(
                    mload(add(transcript, 0x1820)),
                    mload(add(transcript, 0x1840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f20),
                mulmod(
                    mload(add(transcript, 0x1860)),
                    mload(add(transcript, 0x1880)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f40),
                mulmod(
                    mload(add(transcript, 0x18a0)),
                    mload(add(transcript, 0x18c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f60),
                mulmod(
                    mload(add(transcript, 0x18e0)),
                    mload(add(transcript, 0x1900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f80),
                mulmod(
                    mload(add(transcript, 0x1920)),
                    mload(add(transcript, 0x1940)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1fa0),
                mulmod(
                    mload(add(transcript, 0x1960)),
                    mload(add(transcript, 0x1980)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x1e00)),
                    mload(add(transcript, 0x20)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1e20)),
                        mload(add(transcript, 0x40)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1e40)),
                        mload(add(transcript, 0x60)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1e60)),
                        mload(add(transcript, 0x80)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1e80)),
                        mload(add(transcript, 0xa0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ea0)),
                        mload(add(transcript, 0xc0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ec0)),
                        mload(add(transcript, 0xe0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ee0)),
                        mload(add(transcript, 0x100)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1f00)),
                        mload(add(transcript, 0x120)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1f20)),
                        mload(add(transcript, 0x140)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1f40)),
                        mload(add(transcript, 0x160)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1f60)),
                        mload(add(transcript, 0x180)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1f80)),
                        mload(add(transcript, 0x1a0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1fa0)),
                        mload(add(transcript, 0x1c0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x1fc0), result)
            }
            mstore(
                add(transcript, 0x1fe0),
                addmod(2, sub(f_q, mload(add(transcript, 0xae0))), f_q)
            )
            mstore(
                add(transcript, 0x2000),
                mulmod(
                    mload(add(transcript, 0x1fe0)),
                    mload(add(transcript, 0xae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2020),
                mulmod(
                    mload(add(transcript, 0x840)),
                    mload(add(transcript, 0x820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2040),
                addmod(
                    mload(add(transcript, 0x800)),
                    mload(add(transcript, 0x2020)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2060),
                addmod(
                    mload(add(transcript, 0x2040)),
                    sub(f_q, mload(add(transcript, 0x860))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2080),
                mulmod(
                    mload(add(transcript, 0x2060)),
                    mload(add(transcript, 0x2000)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x20a0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2080)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x20c0),
                addmod(2, sub(f_q, mload(add(transcript, 0xb00))), f_q)
            )
            mstore(
                add(transcript, 0x20e0),
                mulmod(
                    mload(add(transcript, 0x20c0)),
                    mload(add(transcript, 0xb00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2100),
                mulmod(
                    mload(add(transcript, 0x8c0)),
                    mload(add(transcript, 0x8a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2120),
                addmod(
                    mload(add(transcript, 0x880)),
                    mload(add(transcript, 0x2100)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2140),
                addmod(
                    mload(add(transcript, 0x2120)),
                    sub(f_q, mload(add(transcript, 0x8e0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2160),
                mulmod(
                    mload(add(transcript, 0x2140)),
                    mload(add(transcript, 0x20e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2180),
                addmod(
                    mload(add(transcript, 0x20a0)),
                    mload(add(transcript, 0x2160)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x21a0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2180)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x21c0),
                addmod(1, sub(f_q, mload(add(transcript, 0xae0))), f_q)
            )
            mstore(
                add(transcript, 0x21e0),
                mulmod(
                    mload(add(transcript, 0x21c0)),
                    mload(add(transcript, 0xae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2200),
                mulmod(
                    mload(add(transcript, 0x940)),
                    mload(add(transcript, 0x920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2220),
                addmod(
                    mload(add(transcript, 0x900)),
                    mload(add(transcript, 0x2200)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2240),
                addmod(
                    mload(add(transcript, 0x2220)),
                    sub(f_q, mload(add(transcript, 0x960))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2260),
                mulmod(
                    mload(add(transcript, 0x2240)),
                    mload(add(transcript, 0x21e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2280),
                addmod(
                    mload(add(transcript, 0x21a0)),
                    mload(add(transcript, 0x2260)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x22a0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2280)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x22c0),
                addmod(1, sub(f_q, mload(add(transcript, 0xb00))), f_q)
            )
            mstore(
                add(transcript, 0x22e0),
                mulmod(
                    mload(add(transcript, 0x22c0)),
                    mload(add(transcript, 0xb00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2300),
                mulmod(
                    mload(add(transcript, 0x9c0)),
                    mload(add(transcript, 0x9a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2320),
                addmod(
                    mload(add(transcript, 0x980)),
                    mload(add(transcript, 0x2300)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2340),
                addmod(
                    mload(add(transcript, 0x2320)),
                    sub(f_q, mload(add(transcript, 0x9e0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2360),
                mulmod(
                    mload(add(transcript, 0x2340)),
                    mload(add(transcript, 0x22e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2380),
                addmod(
                    mload(add(transcript, 0x22a0)),
                    mload(add(transcript, 0x2360)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23a0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2380)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23c0),
                mulmod(
                    mload(add(transcript, 0xa40)),
                    mload(add(transcript, 0xa20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23e0),
                addmod(
                    mload(add(transcript, 0xa00)),
                    mload(add(transcript, 0x23c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2400),
                addmod(
                    mload(add(transcript, 0x23e0)),
                    sub(f_q, mload(add(transcript, 0xa60))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2420),
                mulmod(
                    mload(add(transcript, 0x2400)),
                    mload(add(transcript, 0xb20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2440),
                addmod(
                    mload(add(transcript, 0x23a0)),
                    mload(add(transcript, 0x2420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2460),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2440)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2480),
                addmod(1, sub(f_q, mload(add(transcript, 0xc60))), f_q)
            )
            mstore(
                add(transcript, 0x24a0),
                mulmod(
                    mload(add(transcript, 0x2480)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x24c0),
                addmod(
                    mload(add(transcript, 0x2460)),
                    mload(add(transcript, 0x24a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x24e0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x24c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2500),
                mulmod(
                    mload(add(transcript, 0xd80)),
                    mload(add(transcript, 0xd80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2520),
                addmod(
                    mload(add(transcript, 0x2500)),
                    sub(f_q, mload(add(transcript, 0xd80))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2540),
                mulmod(
                    mload(add(transcript, 0x2520)),
                    mload(add(transcript, 0x1d20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2560),
                addmod(
                    mload(add(transcript, 0x24e0)),
                    mload(add(transcript, 0x2540)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2580),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2560)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25a0),
                addmod(
                    mload(add(transcript, 0xcc0)),
                    sub(f_q, mload(add(transcript, 0xca0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25c0),
                mulmod(
                    mload(add(transcript, 0x25a0)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25e0),
                addmod(
                    mload(add(transcript, 0x2580)),
                    mload(add(transcript, 0x25c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2600),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x25e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2620),
                addmod(
                    mload(add(transcript, 0xd20)),
                    sub(f_q, mload(add(transcript, 0xd00))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2640),
                mulmod(
                    mload(add(transcript, 0x2620)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2660),
                addmod(
                    mload(add(transcript, 0x2600)),
                    mload(add(transcript, 0x2640)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2680),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2660)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26a0),
                addmod(
                    mload(add(transcript, 0xd80)),
                    sub(f_q, mload(add(transcript, 0xd60))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26c0),
                mulmod(
                    mload(add(transcript, 0x26a0)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26e0),
                addmod(
                    mload(add(transcript, 0x2680)),
                    mload(add(transcript, 0x26c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2700),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x26e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2720),
                addmod(1, sub(f_q, mload(add(transcript, 0x1d20))), f_q)
            )
            mstore(
                add(transcript, 0x2740),
                addmod(
                    mload(add(transcript, 0x1d40)),
                    mload(add(transcript, 0x1d60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2760),
                addmod(
                    mload(add(transcript, 0x2740)),
                    mload(add(transcript, 0x1d80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2780),
                addmod(
                    mload(add(transcript, 0x2760)),
                    mload(add(transcript, 0x1da0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27a0),
                addmod(
                    mload(add(transcript, 0x2780)),
                    mload(add(transcript, 0x1dc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27c0),
                addmod(
                    mload(add(transcript, 0x27a0)),
                    mload(add(transcript, 0x1de0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27e0),
                addmod(
                    mload(add(transcript, 0x2720)),
                    sub(f_q, mload(add(transcript, 0x27c0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2800),
                mulmod(
                    mload(add(transcript, 0xb60)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2820),
                addmod(
                    mload(add(transcript, 0xaa0)),
                    mload(add(transcript, 0x2800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2840),
                addmod(
                    mload(add(transcript, 0x2820)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2860),
                mulmod(
                    mload(add(transcript, 0xb80)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2880),
                addmod(
                    mload(add(transcript, 0x800)),
                    mload(add(transcript, 0x2860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28a0),
                addmod(
                    mload(add(transcript, 0x2880)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28c0),
                mulmod(
                    mload(add(transcript, 0x28a0)),
                    mload(add(transcript, 0x2840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28e0),
                mulmod(
                    mload(add(transcript, 0x28c0)),
                    mload(add(transcript, 0xc80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2900),
                mulmod(1, mload(add(transcript, 0x460)), f_q)
            )
            mstore(
                add(transcript, 0x2920),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2940),
                addmod(
                    mload(add(transcript, 0xaa0)),
                    mload(add(transcript, 0x2920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2960),
                addmod(
                    mload(add(transcript, 0x2940)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2980),
                mulmod(
                    4131629893567559867359510883348571134090853742863529169391034518566172092834,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29a0),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29c0),
                addmod(
                    mload(add(transcript, 0x800)),
                    mload(add(transcript, 0x29a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29e0),
                addmod(
                    mload(add(transcript, 0x29c0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a00),
                mulmod(
                    mload(add(transcript, 0x29e0)),
                    mload(add(transcript, 0x2960)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a20),
                mulmod(
                    mload(add(transcript, 0x2a00)),
                    mload(add(transcript, 0xc60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a40),
                addmod(
                    mload(add(transcript, 0x28e0)),
                    sub(f_q, mload(add(transcript, 0x2a20))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a60),
                mulmod(
                    mload(add(transcript, 0x2a40)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a80),
                addmod(
                    mload(add(transcript, 0x2700)),
                    mload(add(transcript, 0x2a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2aa0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2a80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ac0),
                mulmod(
                    mload(add(transcript, 0xba0)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ae0),
                addmod(
                    mload(add(transcript, 0x880)),
                    mload(add(transcript, 0x2ac0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b00),
                addmod(
                    mload(add(transcript, 0x2ae0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b20),
                mulmod(
                    mload(add(transcript, 0xbc0)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b40),
                addmod(
                    mload(add(transcript, 0x900)),
                    mload(add(transcript, 0x2b20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b60),
                addmod(
                    mload(add(transcript, 0x2b40)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b80),
                mulmod(
                    mload(add(transcript, 0x2b60)),
                    mload(add(transcript, 0x2b00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ba0),
                mulmod(
                    mload(add(transcript, 0x2b80)),
                    mload(add(transcript, 0xce0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2bc0),
                mulmod(
                    8910878055287538404433155982483128285667088683464058436815641868457422632747,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2be0),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2bc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c00),
                addmod(
                    mload(add(transcript, 0x880)),
                    mload(add(transcript, 0x2be0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c20),
                addmod(
                    mload(add(transcript, 0x2c00)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c40),
                mulmod(
                    11166246659983828508719468090013646171463329086121580628794302409516816350802,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c60),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2c40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c80),
                addmod(
                    mload(add(transcript, 0x900)),
                    mload(add(transcript, 0x2c60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ca0),
                addmod(
                    mload(add(transcript, 0x2c80)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2cc0),
                mulmod(
                    mload(add(transcript, 0x2ca0)),
                    mload(add(transcript, 0x2c20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ce0),
                mulmod(
                    mload(add(transcript, 0x2cc0)),
                    mload(add(transcript, 0xcc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d00),
                addmod(
                    mload(add(transcript, 0x2ba0)),
                    sub(f_q, mload(add(transcript, 0x2ce0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d20),
                mulmod(
                    mload(add(transcript, 0x2d00)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d40),
                addmod(
                    mload(add(transcript, 0x2aa0)),
                    mload(add(transcript, 0x2d20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d60),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x2d40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d80),
                mulmod(
                    mload(add(transcript, 0xbe0)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2da0),
                addmod(
                    mload(add(transcript, 0x980)),
                    mload(add(transcript, 0x2d80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2dc0),
                addmod(
                    mload(add(transcript, 0x2da0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2de0),
                mulmod(
                    mload(add(transcript, 0xc00)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e00),
                addmod(
                    mload(add(transcript, 0xa00)),
                    mload(add(transcript, 0x2de0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e20),
                addmod(
                    mload(add(transcript, 0x2e00)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e40),
                mulmod(
                    mload(add(transcript, 0x2e20)),
                    mload(add(transcript, 0x2dc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e60),
                mulmod(
                    mload(add(transcript, 0x2e40)),
                    mload(add(transcript, 0xd40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e80),
                mulmod(
                    284840088355319032285349970403338060113257071685626700086398481893096618818,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ea0),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2e80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ec0),
                addmod(
                    mload(add(transcript, 0x980)),
                    mload(add(transcript, 0x2ea0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ee0),
                addmod(
                    mload(add(transcript, 0x2ec0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f00),
                mulmod(
                    21134065618345176623193549882539580312263652408302468683943992798037078993309,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f20),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x2f00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f40),
                addmod(
                    mload(add(transcript, 0xa00)),
                    mload(add(transcript, 0x2f20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f60),
                addmod(
                    mload(add(transcript, 0x2f40)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f80),
                mulmod(
                    mload(add(transcript, 0x2f60)),
                    mload(add(transcript, 0x2ee0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2fa0),
                mulmod(
                    mload(add(transcript, 0x2f80)),
                    mload(add(transcript, 0xd20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2fc0),
                addmod(
                    mload(add(transcript, 0x2e60)),
                    sub(f_q, mload(add(transcript, 0x2fa0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2fe0),
                mulmod(
                    mload(add(transcript, 0x2fc0)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3000),
                addmod(
                    mload(add(transcript, 0x2d60)),
                    mload(add(transcript, 0x2fe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3020),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x3000)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3040),
                mulmod(
                    mload(add(transcript, 0xc20)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3060),
                addmod(
                    mload(add(transcript, 0xa80)),
                    mload(add(transcript, 0x3040)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3080),
                addmod(
                    mload(add(transcript, 0x3060)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x30a0),
                mulmod(
                    mload(add(transcript, 0xc40)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x30c0),
                addmod(
                    mload(add(transcript, 0x1fc0)),
                    mload(add(transcript, 0x30a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x30e0),
                addmod(
                    mload(add(transcript, 0x30c0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3100),
                mulmod(
                    mload(add(transcript, 0x30e0)),
                    mload(add(transcript, 0x3080)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3120),
                mulmod(
                    mload(add(transcript, 0x3100)),
                    mload(add(transcript, 0xda0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3140),
                mulmod(
                    5625741653535312224677218588085279924365897425605943700675464992185016992283,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3160),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x3140)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3180),
                addmod(
                    mload(add(transcript, 0xa80)),
                    mload(add(transcript, 0x3160)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x31a0),
                addmod(
                    mload(add(transcript, 0x3180)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x31c0),
                mulmod(
                    14704729814417906439424896605881467874595262020190401576785074330126828718155,
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x31e0),
                mulmod(
                    mload(add(transcript, 0x7c0)),
                    mload(add(transcript, 0x31c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3200),
                addmod(
                    mload(add(transcript, 0x1fc0)),
                    mload(add(transcript, 0x31e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3220),
                addmod(
                    mload(add(transcript, 0x3200)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3240),
                mulmod(
                    mload(add(transcript, 0x3220)),
                    mload(add(transcript, 0x31a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3260),
                mulmod(
                    mload(add(transcript, 0x3240)),
                    mload(add(transcript, 0xd80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3280),
                addmod(
                    mload(add(transcript, 0x3120)),
                    sub(f_q, mload(add(transcript, 0x3260))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x32a0),
                mulmod(
                    mload(add(transcript, 0x3280)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x32c0),
                addmod(
                    mload(add(transcript, 0x3020)),
                    mload(add(transcript, 0x32a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x32e0),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x32c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3300),
                addmod(1, sub(f_q, mload(add(transcript, 0xdc0))), f_q)
            )
            mstore(
                add(transcript, 0x3320),
                mulmod(
                    mload(add(transcript, 0x3300)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3340),
                addmod(
                    mload(add(transcript, 0x32e0)),
                    mload(add(transcript, 0x3320)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3360),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x3340)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3380),
                mulmod(
                    mload(add(transcript, 0xdc0)),
                    mload(add(transcript, 0xdc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x33a0),
                addmod(
                    mload(add(transcript, 0x3380)),
                    sub(f_q, mload(add(transcript, 0xdc0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x33c0),
                mulmod(
                    mload(add(transcript, 0x33a0)),
                    mload(add(transcript, 0x1d20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x33e0),
                addmod(
                    mload(add(transcript, 0x3360)),
                    mload(add(transcript, 0x33c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3400),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x33e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3420),
                addmod(
                    mload(add(transcript, 0xe00)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3440),
                mulmod(
                    mload(add(transcript, 0x3420)),
                    mload(add(transcript, 0xde0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3460),
                addmod(
                    mload(add(transcript, 0xe40)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3480),
                mulmod(
                    mload(add(transcript, 0x3460)),
                    mload(add(transcript, 0x3440)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x34a0),
                addmod(
                    mload(add(transcript, 0xa80)),
                    mload(add(transcript, 0x460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x34c0),
                mulmod(
                    mload(add(transcript, 0x34a0)),
                    mload(add(transcript, 0xdc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x34e0),
                addmod(
                    mload(add(transcript, 0xac0)),
                    mload(add(transcript, 0x4c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3500),
                mulmod(
                    mload(add(transcript, 0x34e0)),
                    mload(add(transcript, 0x34c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3520),
                addmod(
                    mload(add(transcript, 0x3480)),
                    sub(f_q, mload(add(transcript, 0x3500))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3540),
                mulmod(
                    mload(add(transcript, 0x3520)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3560),
                addmod(
                    mload(add(transcript, 0x3400)),
                    mload(add(transcript, 0x3540)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3580),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x3560)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x35a0),
                addmod(
                    mload(add(transcript, 0xe00)),
                    sub(f_q, mload(add(transcript, 0xe40))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x35c0),
                mulmod(
                    mload(add(transcript, 0x35a0)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x35e0),
                addmod(
                    mload(add(transcript, 0x3580)),
                    mload(add(transcript, 0x35c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3600),
                mulmod(
                    mload(add(transcript, 0x6a0)),
                    mload(add(transcript, 0x35e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3620),
                mulmod(
                    mload(add(transcript, 0x35a0)),
                    mload(add(transcript, 0x27e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3640),
                addmod(
                    mload(add(transcript, 0xe00)),
                    sub(f_q, mload(add(transcript, 0xe20))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3660),
                mulmod(
                    mload(add(transcript, 0x3640)),
                    mload(add(transcript, 0x3620)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3680),
                addmod(
                    mload(add(transcript, 0x3600)),
                    mload(add(transcript, 0x3660)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x36a0),
                mulmod(
                    mload(add(transcript, 0x1400)),
                    mload(add(transcript, 0x1400)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x36c0),
                mulmod(
                    mload(add(transcript, 0x36a0)),
                    mload(add(transcript, 0x1400)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x36e0),
                mulmod(1, mload(add(transcript, 0x1400)), f_q)
            )
            mstore(
                add(transcript, 0x3700),
                mulmod(1, mload(add(transcript, 0x36a0)), f_q)
            )
            mstore(
                add(transcript, 0x3720),
                mulmod(
                    mload(add(transcript, 0x3680)),
                    mload(add(transcript, 0x1420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3740),
                mulmod(
                    mload(add(transcript, 0x1060)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3760),
                mulmod(
                    mload(add(transcript, 0x3740)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3780),
                mulmod(
                    mload(add(transcript, 0x3760)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37a0),
                mulmod(
                    mload(add(transcript, 0x3780)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37c0),
                mulmod(
                    mload(add(transcript, 0x37a0)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37e0),
                mulmod(
                    mload(add(transcript, 0xe80)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3800),
                mulmod(
                    mload(add(transcript, 0x37e0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3820),
                mulmod(
                    mload(add(transcript, 0x3800)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3840),
                mulmod(
                    mload(add(transcript, 0x3820)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3860),
                mulmod(
                    mload(add(transcript, 0x3840)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3880),
                mulmod(
                    mload(add(transcript, 0x3860)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38a0),
                mulmod(
                    mload(add(transcript, 0x3880)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38c0),
                mulmod(
                    mload(add(transcript, 0x38a0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38e0),
                mulmod(
                    mload(add(transcript, 0x38c0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3900),
                mulmod(
                    mload(add(transcript, 0x38e0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3920),
                mulmod(
                    mload(add(transcript, 0x3900)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3940),
                mulmod(
                    mload(add(transcript, 0x3920)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3960),
                mulmod(
                    mload(add(transcript, 0x3940)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3980),
                mulmod(
                    mload(add(transcript, 0x3960)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39a0),
                mulmod(
                    mload(add(transcript, 0x3980)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39c0),
                mulmod(
                    mload(add(transcript, 0x39a0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39e0),
                mulmod(
                    mload(add(transcript, 0x39c0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a00),
                mulmod(
                    mload(add(transcript, 0x39e0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a20),
                mulmod(
                    mload(add(transcript, 0x3a00)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a40),
                mulmod(
                    mload(add(transcript, 0x3a20)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a60),
                mulmod(
                    mload(add(transcript, 0x3a40)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a80),
                mulmod(
                    mload(add(transcript, 0x3a60)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3aa0),
                mulmod(
                    mload(add(transcript, 0x3a80)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ac0),
                mulmod(
                    mload(add(transcript, 0x3aa0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ae0),
                mulmod(
                    mload(add(transcript, 0x3ac0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b00),
                mulmod(
                    mload(add(transcript, 0x3ae0)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b20),
                mulmod(
                    mload(add(transcript, 0x3b00)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b40),
                mulmod(sub(f_q, mload(add(transcript, 0x800))), 1, f_q)
            )
            mstore(
                add(transcript, 0x3b60),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x880))),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b80),
                mulmod(1, mload(add(transcript, 0xe80)), f_q)
            )
            mstore(
                add(transcript, 0x3ba0),
                addmod(
                    mload(add(transcript, 0x3b40)),
                    mload(add(transcript, 0x3b60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3bc0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x900))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3be0),
                mulmod(1, mload(add(transcript, 0x37e0)), f_q)
            )
            mstore(
                add(transcript, 0x3c00),
                addmod(
                    mload(add(transcript, 0x3ba0)),
                    mload(add(transcript, 0x3bc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3c20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x980))),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3c40),
                mulmod(1, mload(add(transcript, 0x3800)), f_q)
            )
            mstore(
                add(transcript, 0x3c60),
                addmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3c20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3c80),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xa00))),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ca0),
                mulmod(1, mload(add(transcript, 0x3820)), f_q)
            )
            mstore(
                add(transcript, 0x3cc0),
                addmod(
                    mload(add(transcript, 0x3c60)),
                    mload(add(transcript, 0x3c80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ce0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xa80))),
                    mload(add(transcript, 0x3840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d00),
                mulmod(1, mload(add(transcript, 0x3840)), f_q)
            )
            mstore(
                add(transcript, 0x3d20),
                addmod(
                    mload(add(transcript, 0x3cc0)),
                    mload(add(transcript, 0x3ce0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d40),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xc60))),
                    mload(add(transcript, 0x3860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d60),
                mulmod(1, mload(add(transcript, 0x3860)), f_q)
            )
            mstore(
                add(transcript, 0x3d80),
                addmod(
                    mload(add(transcript, 0x3d20)),
                    mload(add(transcript, 0x3d40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3da0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xcc0))),
                    mload(add(transcript, 0x3880)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3dc0),
                mulmod(1, mload(add(transcript, 0x3880)), f_q)
            )
            mstore(
                add(transcript, 0x3de0),
                addmod(
                    mload(add(transcript, 0x3d80)),
                    mload(add(transcript, 0x3da0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e00),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xd20))),
                    mload(add(transcript, 0x38a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e20),
                mulmod(1, mload(add(transcript, 0x38a0)), f_q)
            )
            mstore(
                add(transcript, 0x3e40),
                addmod(
                    mload(add(transcript, 0x3de0)),
                    mload(add(transcript, 0x3e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e60),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xd80))),
                    mload(add(transcript, 0x38c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e80),
                mulmod(1, mload(add(transcript, 0x38c0)), f_q)
            )
            mstore(
                add(transcript, 0x3ea0),
                addmod(
                    mload(add(transcript, 0x3e40)),
                    mload(add(transcript, 0x3e60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ec0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xdc0))),
                    mload(add(transcript, 0x38e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ee0),
                mulmod(1, mload(add(transcript, 0x38e0)), f_q)
            )
            mstore(
                add(transcript, 0x3f00),
                addmod(
                    mload(add(transcript, 0x3ea0)),
                    mload(add(transcript, 0x3ec0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xe00))),
                    mload(add(transcript, 0x3900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f40),
                mulmod(1, mload(add(transcript, 0x3900)), f_q)
            )
            mstore(
                add(transcript, 0x3f60),
                addmod(
                    mload(add(transcript, 0x3f00)),
                    mload(add(transcript, 0x3f20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f80),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xe40))),
                    mload(add(transcript, 0x3920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3fa0),
                mulmod(1, mload(add(transcript, 0x3920)), f_q)
            )
            mstore(
                add(transcript, 0x3fc0),
                addmod(
                    mload(add(transcript, 0x3f60)),
                    mload(add(transcript, 0x3f80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3fe0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xaa0))),
                    mload(add(transcript, 0x3940)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4000),
                mulmod(1, mload(add(transcript, 0x3940)), f_q)
            )
            mstore(
                add(transcript, 0x4020),
                addmod(
                    mload(add(transcript, 0x3fc0)),
                    mload(add(transcript, 0x3fe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4040),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xac0))),
                    mload(add(transcript, 0x3960)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4060),
                mulmod(1, mload(add(transcript, 0x3960)), f_q)
            )
            mstore(
                add(transcript, 0x4080),
                addmod(
                    mload(add(transcript, 0x4020)),
                    mload(add(transcript, 0x4040)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x40a0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xae0))),
                    mload(add(transcript, 0x3980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x40c0),
                mulmod(1, mload(add(transcript, 0x3980)), f_q)
            )
            mstore(
                add(transcript, 0x40e0),
                addmod(
                    mload(add(transcript, 0x4080)),
                    mload(add(transcript, 0x40a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4100),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xb00))),
                    mload(add(transcript, 0x39a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4120),
                mulmod(1, mload(add(transcript, 0x39a0)), f_q)
            )
            mstore(
                add(transcript, 0x4140),
                addmod(
                    mload(add(transcript, 0x40e0)),
                    mload(add(transcript, 0x4100)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4160),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xb20))),
                    mload(add(transcript, 0x39c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4180),
                mulmod(1, mload(add(transcript, 0x39c0)), f_q)
            )
            mstore(
                add(transcript, 0x41a0),
                addmod(
                    mload(add(transcript, 0x4140)),
                    mload(add(transcript, 0x4160)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x41c0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xb60))),
                    mload(add(transcript, 0x39e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x41e0),
                mulmod(1, mload(add(transcript, 0x39e0)), f_q)
            )
            mstore(
                add(transcript, 0x4200),
                addmod(
                    mload(add(transcript, 0x41a0)),
                    mload(add(transcript, 0x41c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4220),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xb80))),
                    mload(add(transcript, 0x3a00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4240),
                mulmod(1, mload(add(transcript, 0x3a00)), f_q)
            )
            mstore(
                add(transcript, 0x4260),
                addmod(
                    mload(add(transcript, 0x4200)),
                    mload(add(transcript, 0x4220)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4280),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xba0))),
                    mload(add(transcript, 0x3a20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x42a0),
                mulmod(1, mload(add(transcript, 0x3a20)), f_q)
            )
            mstore(
                add(transcript, 0x42c0),
                addmod(
                    mload(add(transcript, 0x4260)),
                    mload(add(transcript, 0x4280)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x42e0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xbc0))),
                    mload(add(transcript, 0x3a40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4300),
                mulmod(1, mload(add(transcript, 0x3a40)), f_q)
            )
            mstore(
                add(transcript, 0x4320),
                addmod(
                    mload(add(transcript, 0x42c0)),
                    mload(add(transcript, 0x42e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4340),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xbe0))),
                    mload(add(transcript, 0x3a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4360),
                mulmod(1, mload(add(transcript, 0x3a60)), f_q)
            )
            mstore(
                add(transcript, 0x4380),
                addmod(
                    mload(add(transcript, 0x4320)),
                    mload(add(transcript, 0x4340)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x43a0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xc00))),
                    mload(add(transcript, 0x3a80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x43c0),
                mulmod(1, mload(add(transcript, 0x3a80)), f_q)
            )
            mstore(
                add(transcript, 0x43e0),
                addmod(
                    mload(add(transcript, 0x4380)),
                    mload(add(transcript, 0x43a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4400),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xc20))),
                    mload(add(transcript, 0x3aa0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4420),
                mulmod(1, mload(add(transcript, 0x3aa0)), f_q)
            )
            mstore(
                add(transcript, 0x4440),
                addmod(
                    mload(add(transcript, 0x43e0)),
                    mload(add(transcript, 0x4400)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4460),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xc40))),
                    mload(add(transcript, 0x3ac0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4480),
                mulmod(1, mload(add(transcript, 0x3ac0)), f_q)
            )
            mstore(
                add(transcript, 0x44a0),
                addmod(
                    mload(add(transcript, 0x4440)),
                    mload(add(transcript, 0x4460)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x44c0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3720))),
                    mload(add(transcript, 0x3ae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x44e0),
                mulmod(1, mload(add(transcript, 0x3ae0)), f_q)
            )
            mstore(
                add(transcript, 0x4500),
                mulmod(
                    mload(add(transcript, 0x36e0)),
                    mload(add(transcript, 0x3ae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4520),
                mulmod(
                    mload(add(transcript, 0x3700)),
                    mload(add(transcript, 0x3ae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4540),
                addmod(
                    mload(add(transcript, 0x44a0)),
                    mload(add(transcript, 0x44c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4560),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xb40))),
                    mload(add(transcript, 0x3b00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4580),
                mulmod(1, mload(add(transcript, 0x3b00)), f_q)
            )
            mstore(
                add(transcript, 0x45a0),
                addmod(
                    mload(add(transcript, 0x4540)),
                    mload(add(transcript, 0x4560)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x45c0),
                mulmod(mload(add(transcript, 0x45a0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x45e0),
                mulmod(mload(add(transcript, 0x3b80)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4600),
                mulmod(mload(add(transcript, 0x3be0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4620),
                mulmod(mload(add(transcript, 0x3c40)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4640),
                mulmod(mload(add(transcript, 0x3ca0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4660),
                mulmod(mload(add(transcript, 0x3d00)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4680),
                mulmod(mload(add(transcript, 0x3d60)), 1, f_q)
            )
            mstore(
                add(transcript, 0x46a0),
                mulmod(mload(add(transcript, 0x3dc0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x46c0),
                mulmod(mload(add(transcript, 0x3e20)), 1, f_q)
            )
            mstore(
                add(transcript, 0x46e0),
                mulmod(mload(add(transcript, 0x3e80)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4700),
                mulmod(mload(add(transcript, 0x3ee0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4720),
                mulmod(mload(add(transcript, 0x3f40)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4740),
                mulmod(mload(add(transcript, 0x3fa0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4760),
                mulmod(mload(add(transcript, 0x4000)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4780),
                mulmod(mload(add(transcript, 0x4060)), 1, f_q)
            )
            mstore(
                add(transcript, 0x47a0),
                mulmod(mload(add(transcript, 0x40c0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x47c0),
                mulmod(mload(add(transcript, 0x4120)), 1, f_q)
            )
            mstore(
                add(transcript, 0x47e0),
                mulmod(mload(add(transcript, 0x4180)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4800),
                mulmod(mload(add(transcript, 0x41e0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4820),
                mulmod(mload(add(transcript, 0x4240)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4840),
                mulmod(mload(add(transcript, 0x42a0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4860),
                mulmod(mload(add(transcript, 0x4300)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4880),
                mulmod(mload(add(transcript, 0x4360)), 1, f_q)
            )
            mstore(
                add(transcript, 0x48a0),
                mulmod(mload(add(transcript, 0x43c0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x48c0),
                mulmod(mload(add(transcript, 0x4420)), 1, f_q)
            )
            mstore(
                add(transcript, 0x48e0),
                mulmod(mload(add(transcript, 0x4480)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4900),
                mulmod(mload(add(transcript, 0x44e0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4920),
                mulmod(mload(add(transcript, 0x4500)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4940),
                mulmod(mload(add(transcript, 0x4520)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4960),
                mulmod(mload(add(transcript, 0x4580)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4980),
                mulmod(sub(f_q, mload(add(transcript, 0x820))), 1, f_q)
            )
            mstore(
                add(transcript, 0x49a0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x8a0))),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x49c0),
                addmod(
                    mload(add(transcript, 0x4980)),
                    mload(add(transcript, 0x49a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x49e0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x920))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a00),
                addmod(
                    mload(add(transcript, 0x49c0)),
                    mload(add(transcript, 0x49e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x9a0))),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a40),
                addmod(
                    mload(add(transcript, 0x4a00)),
                    mload(add(transcript, 0x4a20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a60),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xa20))),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a80),
                addmod(
                    mload(add(transcript, 0x4a40)),
                    mload(add(transcript, 0x4a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4aa0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xc80))),
                    mload(add(transcript, 0x3840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ac0),
                addmod(
                    mload(add(transcript, 0x4a80)),
                    mload(add(transcript, 0x4aa0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ae0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xce0))),
                    mload(add(transcript, 0x3860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b00),
                addmod(
                    mload(add(transcript, 0x4ac0)),
                    mload(add(transcript, 0x4ae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xd40))),
                    mload(add(transcript, 0x3880)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b40),
                addmod(
                    mload(add(transcript, 0x4b00)),
                    mload(add(transcript, 0x4b20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b60),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xda0))),
                    mload(add(transcript, 0x38a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b80),
                addmod(
                    mload(add(transcript, 0x4b40)),
                    mload(add(transcript, 0x4b60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ba0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xde0))),
                    mload(add(transcript, 0x38c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4bc0),
                addmod(
                    mload(add(transcript, 0x4b80)),
                    mload(add(transcript, 0x4ba0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4be0),
                mulmod(
                    mload(add(transcript, 0x4bc0)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4c00),
                mulmod(1, mload(add(transcript, 0x1060)), f_q)
            )
            mstore(
                add(transcript, 0x4c20),
                mulmod(
                    mload(add(transcript, 0x3b80)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4c40),
                mulmod(
                    mload(add(transcript, 0x3be0)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4c60),
                mulmod(
                    mload(add(transcript, 0x3c40)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4c80),
                mulmod(
                    mload(add(transcript, 0x3ca0)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ca0),
                mulmod(
                    mload(add(transcript, 0x3d00)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4cc0),
                mulmod(
                    mload(add(transcript, 0x3d60)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ce0),
                mulmod(
                    mload(add(transcript, 0x3dc0)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4d00),
                mulmod(
                    mload(add(transcript, 0x3e20)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4d20),
                mulmod(
                    mload(add(transcript, 0x3e80)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4d40),
                addmod(
                    mload(add(transcript, 0x45c0)),
                    mload(add(transcript, 0x4be0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4d60),
                addmod(1, mload(add(transcript, 0x4c00)), f_q)
            )
            mstore(
                add(transcript, 0x4d80),
                addmod(
                    mload(add(transcript, 0x45e0)),
                    mload(add(transcript, 0x4c20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4da0),
                addmod(
                    mload(add(transcript, 0x4600)),
                    mload(add(transcript, 0x4c40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4dc0),
                addmod(
                    mload(add(transcript, 0x4620)),
                    mload(add(transcript, 0x4c60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4de0),
                addmod(
                    mload(add(transcript, 0x4640)),
                    mload(add(transcript, 0x4c80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4e00),
                addmod(
                    mload(add(transcript, 0x4680)),
                    mload(add(transcript, 0x4ca0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4e20),
                addmod(
                    mload(add(transcript, 0x46a0)),
                    mload(add(transcript, 0x4cc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4e40),
                addmod(
                    mload(add(transcript, 0x46c0)),
                    mload(add(transcript, 0x4ce0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4e60),
                addmod(
                    mload(add(transcript, 0x46e0)),
                    mload(add(transcript, 0x4d00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4e80),
                addmod(
                    mload(add(transcript, 0x4700)),
                    mload(add(transcript, 0x4d20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ea0),
                mulmod(sub(f_q, mload(add(transcript, 0x840))), 1, f_q)
            )
            mstore(
                add(transcript, 0x4ec0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x8c0))),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ee0),
                addmod(
                    mload(add(transcript, 0x4ea0)),
                    mload(add(transcript, 0x4ec0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4f00),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x940))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4f20),
                addmod(
                    mload(add(transcript, 0x4ee0)),
                    mload(add(transcript, 0x4f00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4f40),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x9c0))),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4f60),
                addmod(
                    mload(add(transcript, 0x4f20)),
                    mload(add(transcript, 0x4f40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4f80),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xa40))),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4fa0),
                addmod(
                    mload(add(transcript, 0x4f60)),
                    mload(add(transcript, 0x4f80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4fc0),
                mulmod(
                    mload(add(transcript, 0x4fa0)),
                    mload(add(transcript, 0x3740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4fe0),
                mulmod(1, mload(add(transcript, 0x3740)), f_q)
            )
            mstore(
                add(transcript, 0x5000),
                mulmod(
                    mload(add(transcript, 0x3b80)),
                    mload(add(transcript, 0x3740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5020),
                mulmod(
                    mload(add(transcript, 0x3be0)),
                    mload(add(transcript, 0x3740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5040),
                mulmod(
                    mload(add(transcript, 0x3c40)),
                    mload(add(transcript, 0x3740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5060),
                mulmod(
                    mload(add(transcript, 0x3ca0)),
                    mload(add(transcript, 0x3740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5080),
                addmod(
                    mload(add(transcript, 0x4d40)),
                    mload(add(transcript, 0x4fc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x50a0),
                addmod(
                    mload(add(transcript, 0x4d60)),
                    mload(add(transcript, 0x4fe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x50c0),
                addmod(
                    mload(add(transcript, 0x4d80)),
                    mload(add(transcript, 0x5000)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x50e0),
                addmod(
                    mload(add(transcript, 0x4da0)),
                    mload(add(transcript, 0x5020)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5100),
                addmod(
                    mload(add(transcript, 0x4dc0)),
                    mload(add(transcript, 0x5040)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5120),
                addmod(
                    mload(add(transcript, 0x4de0)),
                    mload(add(transcript, 0x5060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5140),
                mulmod(sub(f_q, mload(add(transcript, 0x860))), 1, f_q)
            )
            mstore(
                add(transcript, 0x5160),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x8e0))),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5180),
                addmod(
                    mload(add(transcript, 0x5140)),
                    mload(add(transcript, 0x5160)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x51a0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x960))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x51c0),
                addmod(
                    mload(add(transcript, 0x5180)),
                    mload(add(transcript, 0x51a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x51e0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x9e0))),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5200),
                addmod(
                    mload(add(transcript, 0x51c0)),
                    mload(add(transcript, 0x51e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5220),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xa60))),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5240),
                addmod(
                    mload(add(transcript, 0x5200)),
                    mload(add(transcript, 0x5220)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5260),
                mulmod(
                    mload(add(transcript, 0x5240)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5280),
                mulmod(1, mload(add(transcript, 0x3760)), f_q)
            )
            mstore(
                add(transcript, 0x52a0),
                mulmod(
                    mload(add(transcript, 0x3b80)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x52c0),
                mulmod(
                    mload(add(transcript, 0x3be0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x52e0),
                mulmod(
                    mload(add(transcript, 0x3c40)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5300),
                mulmod(
                    mload(add(transcript, 0x3ca0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5320),
                addmod(
                    mload(add(transcript, 0x5080)),
                    mload(add(transcript, 0x5260)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5340),
                addmod(
                    mload(add(transcript, 0x50a0)),
                    mload(add(transcript, 0x5280)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5360),
                addmod(
                    mload(add(transcript, 0x50c0)),
                    mload(add(transcript, 0x52a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5380),
                addmod(
                    mload(add(transcript, 0x50e0)),
                    mload(add(transcript, 0x52c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x53a0),
                addmod(
                    mload(add(transcript, 0x5100)),
                    mload(add(transcript, 0x52e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x53c0),
                addmod(
                    mload(add(transcript, 0x5120)),
                    mload(add(transcript, 0x5300)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x53e0),
                mulmod(sub(f_q, mload(add(transcript, 0xd60))), 1, f_q)
            )
            mstore(
                add(transcript, 0x5400),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xd00))),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5420),
                addmod(
                    mload(add(transcript, 0x53e0)),
                    mload(add(transcript, 0x5400)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5440),
                mulmod(
                    sub(f_q, mload(add(transcript, 0xca0))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5460),
                addmod(
                    mload(add(transcript, 0x5420)),
                    mload(add(transcript, 0x5440)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5480),
                mulmod(
                    mload(add(transcript, 0x5460)),
                    mload(add(transcript, 0x3780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x54a0),
                mulmod(1, mload(add(transcript, 0x3780)), f_q)
            )
            mstore(
                add(transcript, 0x54c0),
                mulmod(
                    mload(add(transcript, 0x3b80)),
                    mload(add(transcript, 0x3780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x54e0),
                mulmod(
                    mload(add(transcript, 0x3be0)),
                    mload(add(transcript, 0x3780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5500),
                addmod(
                    mload(add(transcript, 0x5320)),
                    mload(add(transcript, 0x5480)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5520),
                addmod(
                    mload(add(transcript, 0x4e40)),
                    mload(add(transcript, 0x54a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5540),
                addmod(
                    mload(add(transcript, 0x4e20)),
                    mload(add(transcript, 0x54c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5560),
                addmod(
                    mload(add(transcript, 0x4e00)),
                    mload(add(transcript, 0x54e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5580),
                mulmod(sub(f_q, mload(add(transcript, 0xe20))), 1, f_q)
            )
            mstore(
                add(transcript, 0x55a0),
                mulmod(
                    mload(add(transcript, 0x5580)),
                    mload(add(transcript, 0x37a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x55c0),
                mulmod(1, mload(add(transcript, 0x37a0)), f_q)
            )
            mstore(
                add(transcript, 0x55e0),
                addmod(
                    mload(add(transcript, 0x5500)),
                    mload(add(transcript, 0x55a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5600),
                addmod(
                    mload(add(transcript, 0x4720)),
                    mload(add(transcript, 0x55c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5620),
                mulmod(1, mload(add(transcript, 0x7c0)), f_q)
            )
            mstore(
                add(transcript, 0x5640),
                mulmod(1, mload(add(transcript, 0x5620)), f_q)
            )
            mstore(
                add(transcript, 0x5660),
                mulmod(
                    11451405578697956743456240853980216273390554734748796433026540431386972584651,
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5680),
                mulmod(
                    mload(add(transcript, 0x4c00)),
                    mload(add(transcript, 0x5660)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x56a0),
                mulmod(
                    8374374965308410102411073611984011876711565317741801500439755773472076597347,
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x56c0),
                mulmod(
                    mload(add(transcript, 0x4fe0)),
                    mload(add(transcript, 0x56a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x56e0),
                mulmod(
                    21490807004895109926141140246143262403290679459142140821740925192625185504522,
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5700),
                mulmod(
                    mload(add(transcript, 0x5280)),
                    mload(add(transcript, 0x56e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5720),
                mulmod(
                    12929131318670223636853686797196826072950305380535537217467769528748593133487,
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5740),
                mulmod(
                    mload(add(transcript, 0x54a0)),
                    mload(add(transcript, 0x5720)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5760),
                mulmod(
                    17329448237240114492580865744088056414251735686965494637158808787419781175510,
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x5780),
                mulmod(
                    mload(add(transcript, 0x55c0)),
                    mload(add(transcript, 0x5760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x57a0),
                0x0000000000000000000000000000000000000000000000000000000000000001
            )
            mstore(
                add(transcript, 0x57c0),
                0x0000000000000000000000000000000000000000000000000000000000000002
            )
            mstore(add(transcript, 0x57e0), mload(add(transcript, 0x55e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x57a0),
                        0x60,
                        add(transcript, 0x57a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5800), mload(add(transcript, 0x1e0)))
            mstore(add(transcript, 0x5820), mload(add(transcript, 0x200)))
            mstore(add(transcript, 0x5840), mload(add(transcript, 0x5340)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5800),
                        0x60,
                        add(transcript, 0x5800),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5860), mload(add(transcript, 0x57a0)))
            mstore(add(transcript, 0x5880), mload(add(transcript, 0x57c0)))
            mstore(add(transcript, 0x58a0), mload(add(transcript, 0x5800)))
            mstore(add(transcript, 0x58c0), mload(add(transcript, 0x5820)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5860),
                        0x80,
                        add(transcript, 0x5860),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x58e0), mload(add(transcript, 0x220)))
            mstore(add(transcript, 0x5900), mload(add(transcript, 0x240)))
            mstore(add(transcript, 0x5920), mload(add(transcript, 0x5360)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x58e0),
                        0x60,
                        add(transcript, 0x58e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5940), mload(add(transcript, 0x5860)))
            mstore(add(transcript, 0x5960), mload(add(transcript, 0x5880)))
            mstore(add(transcript, 0x5980), mload(add(transcript, 0x58e0)))
            mstore(add(transcript, 0x59a0), mload(add(transcript, 0x5900)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5940),
                        0x80,
                        add(transcript, 0x5940),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x59c0), mload(add(transcript, 0x260)))
            mstore(add(transcript, 0x59e0), mload(add(transcript, 0x280)))
            mstore(add(transcript, 0x5a00), mload(add(transcript, 0x5380)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x59c0),
                        0x60,
                        add(transcript, 0x59c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5a20), mload(add(transcript, 0x5940)))
            mstore(add(transcript, 0x5a40), mload(add(transcript, 0x5960)))
            mstore(add(transcript, 0x5a60), mload(add(transcript, 0x59c0)))
            mstore(add(transcript, 0x5a80), mload(add(transcript, 0x59e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5a20),
                        0x80,
                        add(transcript, 0x5a20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5aa0), mload(add(transcript, 0x2a0)))
            mstore(add(transcript, 0x5ac0), mload(add(transcript, 0x2c0)))
            mstore(add(transcript, 0x5ae0), mload(add(transcript, 0x53a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5aa0),
                        0x60,
                        add(transcript, 0x5aa0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5b00), mload(add(transcript, 0x5a20)))
            mstore(add(transcript, 0x5b20), mload(add(transcript, 0x5a40)))
            mstore(add(transcript, 0x5b40), mload(add(transcript, 0x5aa0)))
            mstore(add(transcript, 0x5b60), mload(add(transcript, 0x5ac0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5b00),
                        0x80,
                        add(transcript, 0x5b00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5b80), mload(add(transcript, 0x2e0)))
            mstore(add(transcript, 0x5ba0), mload(add(transcript, 0x300)))
            mstore(add(transcript, 0x5bc0), mload(add(transcript, 0x53c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5b80),
                        0x60,
                        add(transcript, 0x5b80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5be0), mload(add(transcript, 0x5b00)))
            mstore(add(transcript, 0x5c00), mload(add(transcript, 0x5b20)))
            mstore(add(transcript, 0x5c20), mload(add(transcript, 0x5b80)))
            mstore(add(transcript, 0x5c40), mload(add(transcript, 0x5ba0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5be0),
                        0x80,
                        add(transcript, 0x5be0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5c60), mload(add(transcript, 0x320)))
            mstore(add(transcript, 0x5c80), mload(add(transcript, 0x340)))
            mstore(add(transcript, 0x5ca0), mload(add(transcript, 0x4660)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5c60),
                        0x60,
                        add(transcript, 0x5c60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5cc0), mload(add(transcript, 0x5be0)))
            mstore(add(transcript, 0x5ce0), mload(add(transcript, 0x5c00)))
            mstore(add(transcript, 0x5d00), mload(add(transcript, 0x5c60)))
            mstore(add(transcript, 0x5d20), mload(add(transcript, 0x5c80)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5cc0),
                        0x80,
                        add(transcript, 0x5cc0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5d40), mload(add(transcript, 0x500)))
            mstore(add(transcript, 0x5d60), mload(add(transcript, 0x520)))
            mstore(add(transcript, 0x5d80), mload(add(transcript, 0x5560)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5d40),
                        0x60,
                        add(transcript, 0x5d40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5da0), mload(add(transcript, 0x5cc0)))
            mstore(add(transcript, 0x5dc0), mload(add(transcript, 0x5ce0)))
            mstore(add(transcript, 0x5de0), mload(add(transcript, 0x5d40)))
            mstore(add(transcript, 0x5e00), mload(add(transcript, 0x5d60)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5da0),
                        0x80,
                        add(transcript, 0x5da0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5e20), mload(add(transcript, 0x540)))
            mstore(add(transcript, 0x5e40), mload(add(transcript, 0x560)))
            mstore(add(transcript, 0x5e60), mload(add(transcript, 0x5540)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5e20),
                        0x60,
                        add(transcript, 0x5e20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5e80), mload(add(transcript, 0x5da0)))
            mstore(add(transcript, 0x5ea0), mload(add(transcript, 0x5dc0)))
            mstore(add(transcript, 0x5ec0), mload(add(transcript, 0x5e20)))
            mstore(add(transcript, 0x5ee0), mload(add(transcript, 0x5e40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5e80),
                        0x80,
                        add(transcript, 0x5e80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5f00), mload(add(transcript, 0x580)))
            mstore(add(transcript, 0x5f20), mload(add(transcript, 0x5a0)))
            mstore(add(transcript, 0x5f40), mload(add(transcript, 0x5520)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5f00),
                        0x60,
                        add(transcript, 0x5f00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5f60), mload(add(transcript, 0x5e80)))
            mstore(add(transcript, 0x5f80), mload(add(transcript, 0x5ea0)))
            mstore(add(transcript, 0x5fa0), mload(add(transcript, 0x5f00)))
            mstore(add(transcript, 0x5fc0), mload(add(transcript, 0x5f20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5f60),
                        0x80,
                        add(transcript, 0x5f60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5fe0), mload(add(transcript, 0x5c0)))
            mstore(add(transcript, 0x6000), mload(add(transcript, 0x5e0)))
            mstore(add(transcript, 0x6020), mload(add(transcript, 0x4e60)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5fe0),
                        0x60,
                        add(transcript, 0x5fe0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6040), mload(add(transcript, 0x5f60)))
            mstore(add(transcript, 0x6060), mload(add(transcript, 0x5f80)))
            mstore(add(transcript, 0x6080), mload(add(transcript, 0x5fe0)))
            mstore(add(transcript, 0x60a0), mload(add(transcript, 0x6000)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6040),
                        0x80,
                        add(transcript, 0x6040),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x60c0), mload(add(transcript, 0x600)))
            mstore(add(transcript, 0x60e0), mload(add(transcript, 0x620)))
            mstore(add(transcript, 0x6100), mload(add(transcript, 0x4e80)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x60c0),
                        0x60,
                        add(transcript, 0x60c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6120), mload(add(transcript, 0x6040)))
            mstore(add(transcript, 0x6140), mload(add(transcript, 0x6060)))
            mstore(add(transcript, 0x6160), mload(add(transcript, 0x60c0)))
            mstore(add(transcript, 0x6180), mload(add(transcript, 0x60e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6120),
                        0x80,
                        add(transcript, 0x6120),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x61a0), mload(add(transcript, 0x3c0)))
            mstore(add(transcript, 0x61c0), mload(add(transcript, 0x3e0)))
            mstore(add(transcript, 0x61e0), mload(add(transcript, 0x5600)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x61a0),
                        0x60,
                        add(transcript, 0x61a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6200), mload(add(transcript, 0x6120)))
            mstore(add(transcript, 0x6220), mload(add(transcript, 0x6140)))
            mstore(add(transcript, 0x6240), mload(add(transcript, 0x61a0)))
            mstore(add(transcript, 0x6260), mload(add(transcript, 0x61c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6200),
                        0x80,
                        add(transcript, 0x6200),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6280), mload(add(transcript, 0x400)))
            mstore(add(transcript, 0x62a0), mload(add(transcript, 0x420)))
            mstore(add(transcript, 0x62c0), mload(add(transcript, 0x4740)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6280),
                        0x60,
                        add(transcript, 0x6280),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x62e0), mload(add(transcript, 0x6200)))
            mstore(add(transcript, 0x6300), mload(add(transcript, 0x6220)))
            mstore(add(transcript, 0x6320), mload(add(transcript, 0x6280)))
            mstore(add(transcript, 0x6340), mload(add(transcript, 0x62a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x62e0),
                        0x80,
                        add(transcript, 0x62e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6360),
                0x22b8a9dc1c3b6b29b0c6cc69847117f83ab2e7ff09aa2ae1061fe2ad7823ef0e
            )
            mstore(
                add(transcript, 0x6380),
                0x09d619d579ed0c19ee728ab639d5d5ff472ec73357078aa8c3e05a0176f67cf8
            )
            mstore(add(transcript, 0x63a0), mload(add(transcript, 0x4760)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6360),
                        0x60,
                        add(transcript, 0x6360),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x63c0), mload(add(transcript, 0x62e0)))
            mstore(add(transcript, 0x63e0), mload(add(transcript, 0x6300)))
            mstore(add(transcript, 0x6400), mload(add(transcript, 0x6360)))
            mstore(add(transcript, 0x6420), mload(add(transcript, 0x6380)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x63c0),
                        0x80,
                        add(transcript, 0x63c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6440),
                0x248957605e6f0a9881ec2c4a375e8898dc8e6ce1f1bfb4ff6abd470567f7ce62
            )
            mstore(
                add(transcript, 0x6460),
                0x0dae09ba53352990ed2e4c8d4bf920465eb536adc193bf348be452950324c2a5
            )
            mstore(add(transcript, 0x6480), mload(add(transcript, 0x4780)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6440),
                        0x60,
                        add(transcript, 0x6440),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x64a0), mload(add(transcript, 0x63c0)))
            mstore(add(transcript, 0x64c0), mload(add(transcript, 0x63e0)))
            mstore(add(transcript, 0x64e0), mload(add(transcript, 0x6440)))
            mstore(add(transcript, 0x6500), mload(add(transcript, 0x6460)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x64a0),
                        0x80,
                        add(transcript, 0x64a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6520),
                0x0746565349fa838113d6e22f6eeee50afda3ece55e9fc61033d2d7581e1b0beb
            )
            mstore(
                add(transcript, 0x6540),
                0x1edfbf694a342fd209f6e138dff614e3ee385d654127562da94d034b3672320f
            )
            mstore(add(transcript, 0x6560), mload(add(transcript, 0x47a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6520),
                        0x60,
                        add(transcript, 0x6520),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6580), mload(add(transcript, 0x64a0)))
            mstore(add(transcript, 0x65a0), mload(add(transcript, 0x64c0)))
            mstore(add(transcript, 0x65c0), mload(add(transcript, 0x6520)))
            mstore(add(transcript, 0x65e0), mload(add(transcript, 0x6540)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6580),
                        0x80,
                        add(transcript, 0x6580),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6600),
                0x1de290667ab896334f3d1e63bfcfcbd8793366932c9d157e21909937125cec1d
            )
            mstore(
                add(transcript, 0x6620),
                0x2bcf134b635413c692e3626df4f19987c73e952cb366d8ba5f29eeb191085316
            )
            mstore(add(transcript, 0x6640), mload(add(transcript, 0x47c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6600),
                        0x60,
                        add(transcript, 0x6600),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6660), mload(add(transcript, 0x6580)))
            mstore(add(transcript, 0x6680), mload(add(transcript, 0x65a0)))
            mstore(add(transcript, 0x66a0), mload(add(transcript, 0x6600)))
            mstore(add(transcript, 0x66c0), mload(add(transcript, 0x6620)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6660),
                        0x80,
                        add(transcript, 0x6660),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x66e0),
                0x0000000000000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(transcript, 0x6700),
                0x0000000000000000000000000000000000000000000000000000000000000000
            )
            mstore(add(transcript, 0x6720), mload(add(transcript, 0x47e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x66e0),
                        0x60,
                        add(transcript, 0x66e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6740), mload(add(transcript, 0x6660)))
            mstore(add(transcript, 0x6760), mload(add(transcript, 0x6680)))
            mstore(add(transcript, 0x6780), mload(add(transcript, 0x66e0)))
            mstore(add(transcript, 0x67a0), mload(add(transcript, 0x6700)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6740),
                        0x80,
                        add(transcript, 0x6740),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x67c0),
                0x204b235e143df561b61cd8e9b8aa4d16abd77f6947c5fd7040dcb59b9be5d19f
            )
            mstore(
                add(transcript, 0x67e0),
                0x08f092b2c758f020d6390d7f8312ab3bc2ae3be30134826e68aea073d3d1abb9
            )
            mstore(add(transcript, 0x6800), mload(add(transcript, 0x4800)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x67c0),
                        0x60,
                        add(transcript, 0x67c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6820), mload(add(transcript, 0x6740)))
            mstore(add(transcript, 0x6840), mload(add(transcript, 0x6760)))
            mstore(add(transcript, 0x6860), mload(add(transcript, 0x67c0)))
            mstore(add(transcript, 0x6880), mload(add(transcript, 0x67e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6820),
                        0x80,
                        add(transcript, 0x6820),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x68a0),
                0x1c025e89f11345fd0e08a99db3933080448a7762f64c9d93fd2ffa6150cdc63d
            )
            mstore(
                add(transcript, 0x68c0),
                0x13ac4f40d955d10518554ef6498d7abe576ada305822052c12262c79922fdaac
            )
            mstore(add(transcript, 0x68e0), mload(add(transcript, 0x4820)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x68a0),
                        0x60,
                        add(transcript, 0x68a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6900), mload(add(transcript, 0x6820)))
            mstore(add(transcript, 0x6920), mload(add(transcript, 0x6840)))
            mstore(add(transcript, 0x6940), mload(add(transcript, 0x68a0)))
            mstore(add(transcript, 0x6960), mload(add(transcript, 0x68c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6900),
                        0x80,
                        add(transcript, 0x6900),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6980),
                0x279b719af0c989c0c6b310344d27605d0854a679213e6abd4e606ef96cf75604
            )
            mstore(
                add(transcript, 0x69a0),
                0x29a7d98bbf4f490d158942c8aecb430983296180f31f253b79f8a3c68af923f0
            )
            mstore(add(transcript, 0x69c0), mload(add(transcript, 0x4840)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6980),
                        0x60,
                        add(transcript, 0x6980),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x69e0), mload(add(transcript, 0x6900)))
            mstore(add(transcript, 0x6a00), mload(add(transcript, 0x6920)))
            mstore(add(transcript, 0x6a20), mload(add(transcript, 0x6980)))
            mstore(add(transcript, 0x6a40), mload(add(transcript, 0x69a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x69e0),
                        0x80,
                        add(transcript, 0x69e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6a60),
                0x0508bd933159f8c13b7c790d7c4fe5fad9e19206e8399bde7730b7bd792d8df0
            )
            mstore(
                add(transcript, 0x6a80),
                0x0d9e81c9c1f8839c882eb3a2c82e0244ad8dd28d0dcaa961f13888049a86a6c8
            )
            mstore(add(transcript, 0x6aa0), mload(add(transcript, 0x4860)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6a60),
                        0x60,
                        add(transcript, 0x6a60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6ac0), mload(add(transcript, 0x69e0)))
            mstore(add(transcript, 0x6ae0), mload(add(transcript, 0x6a00)))
            mstore(add(transcript, 0x6b00), mload(add(transcript, 0x6a60)))
            mstore(add(transcript, 0x6b20), mload(add(transcript, 0x6a80)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6ac0),
                        0x80,
                        add(transcript, 0x6ac0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6b40),
                0x2da0d8301c71ae5a875a46d800b778bfe7783aa85a9124887439c47d7e467b57
            )
            mstore(
                add(transcript, 0x6b60),
                0x2e865f632a8775b2044bf4f8133c051c01d7e0b7aa6c515c10b1b1507be66679
            )
            mstore(add(transcript, 0x6b80), mload(add(transcript, 0x4880)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6b40),
                        0x60,
                        add(transcript, 0x6b40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6ba0), mload(add(transcript, 0x6ac0)))
            mstore(add(transcript, 0x6bc0), mload(add(transcript, 0x6ae0)))
            mstore(add(transcript, 0x6be0), mload(add(transcript, 0x6b40)))
            mstore(add(transcript, 0x6c00), mload(add(transcript, 0x6b60)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6ba0),
                        0x80,
                        add(transcript, 0x6ba0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6c20),
                0x24da7a28646eb4420b7f3cedd3043ef245934d2faa69e351a91fdc6ee9fedc16
            )
            mstore(
                add(transcript, 0x6c40),
                0x2a330bd76a24e482ceffa35a0a26e72599f5c9bfa25cab81d4a2cd6b222b4b6c
            )
            mstore(add(transcript, 0x6c60), mload(add(transcript, 0x48a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6c20),
                        0x60,
                        add(transcript, 0x6c20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6c80), mload(add(transcript, 0x6ba0)))
            mstore(add(transcript, 0x6ca0), mload(add(transcript, 0x6bc0)))
            mstore(add(transcript, 0x6cc0), mload(add(transcript, 0x6c20)))
            mstore(add(transcript, 0x6ce0), mload(add(transcript, 0x6c40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6c80),
                        0x80,
                        add(transcript, 0x6c80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6d00),
                0x06e55b452c02937117716b222faeab8267c9a31b7afaa72a3a7909e948ed0860
            )
            mstore(
                add(transcript, 0x6d20),
                0x12433ca5e6ecbf6ebabb4f8cc7bcb00e74304c53f1682f513b72740fec45df45
            )
            mstore(add(transcript, 0x6d40), mload(add(transcript, 0x48c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6d00),
                        0x60,
                        add(transcript, 0x6d00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6d60), mload(add(transcript, 0x6c80)))
            mstore(add(transcript, 0x6d80), mload(add(transcript, 0x6ca0)))
            mstore(add(transcript, 0x6da0), mload(add(transcript, 0x6d00)))
            mstore(add(transcript, 0x6dc0), mload(add(transcript, 0x6d20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6d60),
                        0x80,
                        add(transcript, 0x6d60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x6de0),
                0x14a5de41fcd0c6e958fa3f3992d91b1182e5e4f89dbeaa699255521bd734281e
            )
            mstore(
                add(transcript, 0x6e00),
                0x0ee7d73e9c2e6a02e2569f988917e5971453e0e1e8dd891fd303737a5224aa80
            )
            mstore(add(transcript, 0x6e20), mload(add(transcript, 0x48e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6de0),
                        0x60,
                        add(transcript, 0x6de0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6e40), mload(add(transcript, 0x6d60)))
            mstore(add(transcript, 0x6e60), mload(add(transcript, 0x6d80)))
            mstore(add(transcript, 0x6e80), mload(add(transcript, 0x6de0)))
            mstore(add(transcript, 0x6ea0), mload(add(transcript, 0x6e00)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6e40),
                        0x80,
                        add(transcript, 0x6e40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6ec0), mload(add(transcript, 0x6e0)))
            mstore(add(transcript, 0x6ee0), mload(add(transcript, 0x700)))
            mstore(add(transcript, 0x6f00), mload(add(transcript, 0x4900)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6ec0),
                        0x60,
                        add(transcript, 0x6ec0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6f20), mload(add(transcript, 0x6e40)))
            mstore(add(transcript, 0x6f40), mload(add(transcript, 0x6e60)))
            mstore(add(transcript, 0x6f60), mload(add(transcript, 0x6ec0)))
            mstore(add(transcript, 0x6f80), mload(add(transcript, 0x6ee0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6f20),
                        0x80,
                        add(transcript, 0x6f20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6fa0), mload(add(transcript, 0x720)))
            mstore(add(transcript, 0x6fc0), mload(add(transcript, 0x740)))
            mstore(add(transcript, 0x6fe0), mload(add(transcript, 0x4920)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6fa0),
                        0x60,
                        add(transcript, 0x6fa0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7000), mload(add(transcript, 0x6f20)))
            mstore(add(transcript, 0x7020), mload(add(transcript, 0x6f40)))
            mstore(add(transcript, 0x7040), mload(add(transcript, 0x6fa0)))
            mstore(add(transcript, 0x7060), mload(add(transcript, 0x6fc0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7000),
                        0x80,
                        add(transcript, 0x7000),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7080), mload(add(transcript, 0x760)))
            mstore(add(transcript, 0x70a0), mload(add(transcript, 0x780)))
            mstore(add(transcript, 0x70c0), mload(add(transcript, 0x4940)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7080),
                        0x60,
                        add(transcript, 0x7080),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x70e0), mload(add(transcript, 0x7000)))
            mstore(add(transcript, 0x7100), mload(add(transcript, 0x7020)))
            mstore(add(transcript, 0x7120), mload(add(transcript, 0x7080)))
            mstore(add(transcript, 0x7140), mload(add(transcript, 0x70a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x70e0),
                        0x80,
                        add(transcript, 0x70e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7160), mload(add(transcript, 0x640)))
            mstore(add(transcript, 0x7180), mload(add(transcript, 0x660)))
            mstore(add(transcript, 0x71a0), mload(add(transcript, 0x4960)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7160),
                        0x60,
                        add(transcript, 0x7160),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x71c0), mload(add(transcript, 0x70e0)))
            mstore(add(transcript, 0x71e0), mload(add(transcript, 0x7100)))
            mstore(add(transcript, 0x7200), mload(add(transcript, 0x7160)))
            mstore(add(transcript, 0x7220), mload(add(transcript, 0x7180)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x71c0),
                        0x80,
                        add(transcript, 0x71c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7240), mload(add(transcript, 0xec0)))
            mstore(add(transcript, 0x7260), mload(add(transcript, 0xee0)))
            mstore(add(transcript, 0x7280), mload(add(transcript, 0x5640)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7240),
                        0x60,
                        add(transcript, 0x7240),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x72a0), mload(add(transcript, 0x71c0)))
            mstore(add(transcript, 0x72c0), mload(add(transcript, 0x71e0)))
            mstore(add(transcript, 0x72e0), mload(add(transcript, 0x7240)))
            mstore(add(transcript, 0x7300), mload(add(transcript, 0x7260)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x72a0),
                        0x80,
                        add(transcript, 0x72a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7320), mload(add(transcript, 0xf00)))
            mstore(add(transcript, 0x7340), mload(add(transcript, 0xf20)))
            mstore(add(transcript, 0x7360), mload(add(transcript, 0x5680)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7320),
                        0x60,
                        add(transcript, 0x7320),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7380), mload(add(transcript, 0x72a0)))
            mstore(add(transcript, 0x73a0), mload(add(transcript, 0x72c0)))
            mstore(add(transcript, 0x73c0), mload(add(transcript, 0x7320)))
            mstore(add(transcript, 0x73e0), mload(add(transcript, 0x7340)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7380),
                        0x80,
                        add(transcript, 0x7380),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7400), mload(add(transcript, 0xf40)))
            mstore(add(transcript, 0x7420), mload(add(transcript, 0xf60)))
            mstore(add(transcript, 0x7440), mload(add(transcript, 0x56c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7400),
                        0x60,
                        add(transcript, 0x7400),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7460), mload(add(transcript, 0x7380)))
            mstore(add(transcript, 0x7480), mload(add(transcript, 0x73a0)))
            mstore(add(transcript, 0x74a0), mload(add(transcript, 0x7400)))
            mstore(add(transcript, 0x74c0), mload(add(transcript, 0x7420)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7460),
                        0x80,
                        add(transcript, 0x7460),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x74e0), mload(add(transcript, 0xf80)))
            mstore(add(transcript, 0x7500), mload(add(transcript, 0xfa0)))
            mstore(add(transcript, 0x7520), mload(add(transcript, 0x5700)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x74e0),
                        0x60,
                        add(transcript, 0x74e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7540), mload(add(transcript, 0x7460)))
            mstore(add(transcript, 0x7560), mload(add(transcript, 0x7480)))
            mstore(add(transcript, 0x7580), mload(add(transcript, 0x74e0)))
            mstore(add(transcript, 0x75a0), mload(add(transcript, 0x7500)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7540),
                        0x80,
                        add(transcript, 0x7540),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x75c0), mload(add(transcript, 0xfc0)))
            mstore(add(transcript, 0x75e0), mload(add(transcript, 0xfe0)))
            mstore(add(transcript, 0x7600), mload(add(transcript, 0x5740)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x75c0),
                        0x60,
                        add(transcript, 0x75c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7620), mload(add(transcript, 0x7540)))
            mstore(add(transcript, 0x7640), mload(add(transcript, 0x7560)))
            mstore(add(transcript, 0x7660), mload(add(transcript, 0x75c0)))
            mstore(add(transcript, 0x7680), mload(add(transcript, 0x75e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7620),
                        0x80,
                        add(transcript, 0x7620),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x76a0), mload(add(transcript, 0x1000)))
            mstore(add(transcript, 0x76c0), mload(add(transcript, 0x1020)))
            mstore(add(transcript, 0x76e0), mload(add(transcript, 0x5780)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x76a0),
                        0x60,
                        add(transcript, 0x76a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7700), mload(add(transcript, 0x7620)))
            mstore(add(transcript, 0x7720), mload(add(transcript, 0x7640)))
            mstore(add(transcript, 0x7740), mload(add(transcript, 0x76a0)))
            mstore(add(transcript, 0x7760), mload(add(transcript, 0x76c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7700),
                        0x80,
                        add(transcript, 0x7700),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7780), mload(add(transcript, 0xf00)))
            mstore(add(transcript, 0x77a0), mload(add(transcript, 0xf20)))
            mstore(add(transcript, 0x77c0), mload(add(transcript, 0x4c00)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7780),
                        0x60,
                        add(transcript, 0x7780),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x77e0), mload(add(transcript, 0xec0)))
            mstore(add(transcript, 0x7800), mload(add(transcript, 0xee0)))
            mstore(add(transcript, 0x7820), mload(add(transcript, 0x7780)))
            mstore(add(transcript, 0x7840), mload(add(transcript, 0x77a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x77e0),
                        0x80,
                        add(transcript, 0x77e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7860), mload(add(transcript, 0xf40)))
            mstore(add(transcript, 0x7880), mload(add(transcript, 0xf60)))
            mstore(add(transcript, 0x78a0), mload(add(transcript, 0x4fe0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7860),
                        0x60,
                        add(transcript, 0x7860),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x78c0), mload(add(transcript, 0x77e0)))
            mstore(add(transcript, 0x78e0), mload(add(transcript, 0x7800)))
            mstore(add(transcript, 0x7900), mload(add(transcript, 0x7860)))
            mstore(add(transcript, 0x7920), mload(add(transcript, 0x7880)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x78c0),
                        0x80,
                        add(transcript, 0x78c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7940), mload(add(transcript, 0xf80)))
            mstore(add(transcript, 0x7960), mload(add(transcript, 0xfa0)))
            mstore(add(transcript, 0x7980), mload(add(transcript, 0x5280)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7940),
                        0x60,
                        add(transcript, 0x7940),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x79a0), mload(add(transcript, 0x78c0)))
            mstore(add(transcript, 0x79c0), mload(add(transcript, 0x78e0)))
            mstore(add(transcript, 0x79e0), mload(add(transcript, 0x7940)))
            mstore(add(transcript, 0x7a00), mload(add(transcript, 0x7960)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x79a0),
                        0x80,
                        add(transcript, 0x79a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7a20), mload(add(transcript, 0xfc0)))
            mstore(add(transcript, 0x7a40), mload(add(transcript, 0xfe0)))
            mstore(add(transcript, 0x7a60), mload(add(transcript, 0x54a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7a20),
                        0x60,
                        add(transcript, 0x7a20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7a80), mload(add(transcript, 0x79a0)))
            mstore(add(transcript, 0x7aa0), mload(add(transcript, 0x79c0)))
            mstore(add(transcript, 0x7ac0), mload(add(transcript, 0x7a20)))
            mstore(add(transcript, 0x7ae0), mload(add(transcript, 0x7a40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7a80),
                        0x80,
                        add(transcript, 0x7a80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7b00), mload(add(transcript, 0x1000)))
            mstore(add(transcript, 0x7b20), mload(add(transcript, 0x1020)))
            mstore(add(transcript, 0x7b40), mload(add(transcript, 0x55c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7b00),
                        0x60,
                        add(transcript, 0x7b00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7b60), mload(add(transcript, 0x7a80)))
            mstore(add(transcript, 0x7b80), mload(add(transcript, 0x7aa0)))
            mstore(add(transcript, 0x7ba0), mload(add(transcript, 0x7b00)))
            mstore(add(transcript, 0x7bc0), mload(add(transcript, 0x7b20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7b60),
                        0x80,
                        add(transcript, 0x7b60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7be0), mload(add(transcript, 0x7700)))
            mstore(add(transcript, 0x7c00), mload(add(transcript, 0x7720)))
            mstore(add(transcript, 0x7c20), mload(add(transcript, 0x7b60)))
            mstore(add(transcript, 0x7c40), mload(add(transcript, 0x7b80)))
            mstore(add(transcript, 0x7c60), mload(add(transcript, 0x10a0)))
            mstore(add(transcript, 0x7c80), mload(add(transcript, 0x10c0)))
            mstore(add(transcript, 0x7ca0), mload(add(transcript, 0x10e0)))
            mstore(add(transcript, 0x7cc0), mload(add(transcript, 0x1100)))
            mstore(
                add(transcript, 0x7ce0),
                keccak256(add(transcript, 0x7be0), 256)
            )
            mstore(add(transcript, 0x7d00), mod(mload(31968), f_q))
            mstore(
                add(transcript, 0x7d20),
                mulmod(
                    mload(add(transcript, 0x7d00)),
                    mload(add(transcript, 0x7d00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x7d40),
                mulmod(1, mload(add(transcript, 0x7d00)), f_q)
            )
            mstore(add(transcript, 0x7d60), mload(add(transcript, 0x7c60)))
            mstore(add(transcript, 0x7d80), mload(add(transcript, 0x7c80)))
            mstore(add(transcript, 0x7da0), mload(add(transcript, 0x7d40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7d60),
                        0x60,
                        add(transcript, 0x7d60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7dc0), mload(add(transcript, 0x7be0)))
            mstore(add(transcript, 0x7de0), mload(add(transcript, 0x7c00)))
            mstore(add(transcript, 0x7e00), mload(add(transcript, 0x7d60)))
            mstore(add(transcript, 0x7e20), mload(add(transcript, 0x7d80)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7dc0),
                        0x80,
                        add(transcript, 0x7dc0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7e40), mload(add(transcript, 0x7ca0)))
            mstore(add(transcript, 0x7e60), mload(add(transcript, 0x7cc0)))
            mstore(add(transcript, 0x7e80), mload(add(transcript, 0x7d40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x7e40),
                        0x60,
                        add(transcript, 0x7e40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7ea0), mload(add(transcript, 0x7c20)))
            mstore(add(transcript, 0x7ec0), mload(add(transcript, 0x7c40)))
            mstore(add(transcript, 0x7ee0), mload(add(transcript, 0x7e40)))
            mstore(add(transcript, 0x7f00), mload(add(transcript, 0x7e60)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x7ea0),
                        0x80,
                        add(transcript, 0x7ea0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x7f20), mload(add(transcript, 0x7dc0)))
            mstore(add(transcript, 0x7f40), mload(add(transcript, 0x7de0)))
            mstore(
                add(transcript, 0x7f60),
                0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2
            )
            mstore(
                add(transcript, 0x7f80),
                0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed
            )
            mstore(
                add(transcript, 0x7fa0),
                0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b
            )
            mstore(
                add(transcript, 0x7fc0),
                0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            )
            mstore(add(transcript, 0x7fe0), mload(add(transcript, 0x7ea0)))
            mstore(add(transcript, 0x8000), mload(add(transcript, 0x7ec0)))
            mstore(
                add(transcript, 0x8020),
                0x1cf8832646b03608390dd9a6f7c6de581e065a2c99be3cd7e2259c0738c19051
            )
            mstore(
                add(transcript, 0x8040),
                0x068db4b87c697bd9906371fc2e24e522e20ca527952bfe058b3225974acf545f
            )
            mstore(
                add(transcript, 0x8060),
                0x01fdf661dc9860278308a39ac4e8214b55996acd015119a41baf7dc2ecbcd71b
            )
            mstore(
                add(transcript, 0x8080),
                0x2f69939a4701e1090159fcd62d8804f026626380dc72d6f2fa9ea681671c8800
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x8,
                        add(transcript, 0x7f20),
                        0x180,
                        add(transcript, 0x7f20),
                        0x20
                    ),
                    1
                ),
                success
            )
            success := and(eq(mload(add(transcript, 0x7f20)), 1), success)
        }
        return success;
    }
}
