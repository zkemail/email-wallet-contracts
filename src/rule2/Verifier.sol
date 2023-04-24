// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Rule2Verifier {
    function verify(
        uint256[] memory pubInputs,
        bytes memory proof
    ) public view returns (bool) {
        bool success = true;
        bytes32[829] memory transcript;
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
                add(transcript, 0x0),
                16258268875468025109801601766289138359753205782880550072732758618772675512995
            )
            {
                let x := mload(add(proof, 0x20))
                mstore(add(transcript, 0x1c0), x)
                let y := mload(add(proof, 0x40))
                mstore(add(transcript, 0x1e0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x60))
                mstore(add(transcript, 0x200), x)
                let y := mload(add(proof, 0x80))
                mstore(add(transcript, 0x220), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xa0))
                mstore(add(transcript, 0x240), x)
                let y := mload(add(proof, 0xc0))
                mstore(add(transcript, 0x260), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0xe0))
                mstore(add(transcript, 0x280), x)
                let y := mload(add(proof, 0x100))
                mstore(add(transcript, 0x2a0), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(add(transcript, 0x2c0), keccak256(add(transcript, 0x0), 704))
            {
                let hash := mload(add(transcript, 0x2c0))
                mstore(add(transcript, 0x2e0), mod(hash, f_q))
                mstore(add(transcript, 0x300), hash)
            }
            {
                let x := mload(add(proof, 0x120))
                mstore(add(transcript, 0x320), x)
                let y := mload(add(proof, 0x140))
                mstore(add(transcript, 0x340), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x160))
                mstore(add(transcript, 0x360), x)
                let y := mload(add(proof, 0x180))
                mstore(add(transcript, 0x380), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x3a0),
                keccak256(add(transcript, 0x300), 160)
            )
            {
                let hash := mload(add(transcript, 0x3a0))
                mstore(add(transcript, 0x3c0), mod(hash, f_q))
                mstore(add(transcript, 0x3e0), hash)
            }
            mstore8(add(transcript, 0x400), 1)
            mstore(
                add(transcript, 0x400),
                keccak256(add(transcript, 0x3e0), 33)
            )
            {
                let hash := mload(add(transcript, 0x400))
                mstore(add(transcript, 0x420), mod(hash, f_q))
                mstore(add(transcript, 0x440), hash)
            }
            {
                let x := mload(add(proof, 0x1a0))
                mstore(add(transcript, 0x460), x)
                let y := mload(add(proof, 0x1c0))
                mstore(add(transcript, 0x480), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x1e0))
                mstore(add(transcript, 0x4a0), x)
                let y := mload(add(proof, 0x200))
                mstore(add(transcript, 0x4c0), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x220))
                mstore(add(transcript, 0x4e0), x)
                let y := mload(add(proof, 0x240))
                mstore(add(transcript, 0x500), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x260))
                mstore(add(transcript, 0x520), x)
                let y := mload(add(proof, 0x280))
                mstore(add(transcript, 0x540), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x2a0))
                mstore(add(transcript, 0x560), x)
                let y := mload(add(proof, 0x2c0))
                mstore(add(transcript, 0x580), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x5a0),
                keccak256(add(transcript, 0x440), 352)
            )
            {
                let hash := mload(add(transcript, 0x5a0))
                mstore(add(transcript, 0x5c0), mod(hash, f_q))
                mstore(add(transcript, 0x5e0), hash)
            }
            {
                let x := mload(add(proof, 0x2e0))
                mstore(add(transcript, 0x600), x)
                let y := mload(add(proof, 0x300))
                mstore(add(transcript, 0x620), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x320))
                mstore(add(transcript, 0x640), x)
                let y := mload(add(proof, 0x340))
                mstore(add(transcript, 0x660), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(proof, 0x360))
                mstore(add(transcript, 0x680), x)
                let y := mload(add(proof, 0x380))
                mstore(add(transcript, 0x6a0), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0x6c0),
                keccak256(add(transcript, 0x5e0), 224)
            )
            {
                let hash := mload(add(transcript, 0x6c0))
                mstore(add(transcript, 0x6e0), mod(hash, f_q))
                mstore(add(transcript, 0x700), hash)
            }
            mstore(add(transcript, 0x720), mod(mload(add(proof, 0x3a0)), f_q))
            mstore(add(transcript, 0x740), mod(mload(add(proof, 0x3c0)), f_q))
            mstore(add(transcript, 0x760), mod(mload(add(proof, 0x3e0)), f_q))
            mstore(add(transcript, 0x780), mod(mload(add(proof, 0x400)), f_q))
            mstore(add(transcript, 0x7a0), mod(mload(add(proof, 0x420)), f_q))
            mstore(add(transcript, 0x7c0), mod(mload(add(proof, 0x440)), f_q))
            mstore(add(transcript, 0x7e0), mod(mload(add(proof, 0x460)), f_q))
            mstore(add(transcript, 0x800), mod(mload(add(proof, 0x480)), f_q))
            mstore(add(transcript, 0x820), mod(mload(add(proof, 0x4a0)), f_q))
            mstore(add(transcript, 0x840), mod(mload(add(proof, 0x4c0)), f_q))
            mstore(add(transcript, 0x860), mod(mload(add(proof, 0x4e0)), f_q))
            mstore(add(transcript, 0x880), mod(mload(add(proof, 0x500)), f_q))
            mstore(add(transcript, 0x8a0), mod(mload(add(proof, 0x520)), f_q))
            mstore(add(transcript, 0x8c0), mod(mload(add(proof, 0x540)), f_q))
            mstore(add(transcript, 0x8e0), mod(mload(add(proof, 0x560)), f_q))
            mstore(add(transcript, 0x900), mod(mload(add(proof, 0x580)), f_q))
            mstore(add(transcript, 0x920), mod(mload(add(proof, 0x5a0)), f_q))
            mstore(add(transcript, 0x940), mod(mload(add(proof, 0x5c0)), f_q))
            mstore(add(transcript, 0x960), mod(mload(add(proof, 0x5e0)), f_q))
            mstore(add(transcript, 0x980), mod(mload(add(proof, 0x600)), f_q))
            mstore(add(transcript, 0x9a0), mod(mload(add(proof, 0x620)), f_q))
            mstore(add(transcript, 0x9c0), mod(mload(add(proof, 0x640)), f_q))
            mstore(add(transcript, 0x9e0), mod(mload(add(proof, 0x660)), f_q))
            mstore(add(transcript, 0xa00), mod(mload(add(proof, 0x680)), f_q))
            mstore(add(transcript, 0xa20), mod(mload(add(proof, 0x6a0)), f_q))
            mstore(add(transcript, 0xa40), mod(mload(add(proof, 0x6c0)), f_q))
            mstore(add(transcript, 0xa60), mod(mload(add(proof, 0x6e0)), f_q))
            mstore(add(transcript, 0xa80), mod(mload(add(proof, 0x700)), f_q))
            mstore(add(transcript, 0xaa0), mod(mload(add(proof, 0x720)), f_q))
            mstore(add(transcript, 0xac0), mod(mload(add(proof, 0x740)), f_q))
            mstore(add(transcript, 0xae0), mod(mload(add(proof, 0x760)), f_q))
            mstore(add(transcript, 0xb00), mod(mload(add(proof, 0x780)), f_q))
            mstore(add(transcript, 0xb20), mod(mload(add(proof, 0x7a0)), f_q))
            mstore(add(transcript, 0xb40), mod(mload(add(proof, 0x7c0)), f_q))
            mstore(add(transcript, 0xb60), mod(mload(add(proof, 0x7e0)), f_q))
            mstore(add(transcript, 0xb80), mod(mload(add(proof, 0x800)), f_q))
            mstore(add(transcript, 0xba0), mod(mload(add(proof, 0x820)), f_q))
            mstore(
                add(transcript, 0xbc0),
                keccak256(add(transcript, 0x700), 1216)
            )
            {
                let hash := mload(add(transcript, 0xbc0))
                mstore(add(transcript, 0xbe0), mod(hash, f_q))
                mstore(add(transcript, 0xc00), hash)
            }
            mstore8(add(transcript, 0xc20), 1)
            mstore(
                add(transcript, 0xc20),
                keccak256(add(transcript, 0xc00), 33)
            )
            {
                let hash := mload(add(transcript, 0xc20))
                mstore(add(transcript, 0xc40), mod(hash, f_q))
                mstore(add(transcript, 0xc60), hash)
            }
            {
                let x := mload(add(proof, 0x840))
                mstore(add(transcript, 0xc80), x)
                let y := mload(add(proof, 0x860))
                mstore(add(transcript, 0xca0), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0xcc0),
                keccak256(add(transcript, 0xc60), 96)
            )
            {
                let hash := mload(add(transcript, 0xcc0))
                mstore(add(transcript, 0xce0), mod(hash, f_q))
                mstore(add(transcript, 0xd00), hash)
            }
            {
                let x := mload(add(proof, 0x880))
                mstore(add(transcript, 0xd20), x)
                let y := mload(add(proof, 0x8a0))
                mstore(add(transcript, 0xd40), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(transcript, 0x20))
                x := add(x, shl(88, mload(add(transcript, 0x40))))
                x := add(x, shl(176, mload(add(transcript, 0x60))))
                mstore(add(transcript, 0xd60), x)
                let y := mload(add(transcript, 0x80))
                y := add(y, shl(88, mload(add(transcript, 0xa0))))
                y := add(y, shl(176, mload(add(transcript, 0xc0))))
                mstore(add(transcript, 0xd80), y)
                success := and(validate_ec_point(x, y), success)
            }
            {
                let x := mload(add(transcript, 0xe0))
                x := add(x, shl(88, mload(add(transcript, 0x100))))
                x := add(x, shl(176, mload(add(transcript, 0x120))))
                mstore(add(transcript, 0xda0), x)
                let y := mload(add(transcript, 0x140))
                y := add(y, shl(88, mload(add(transcript, 0x160))))
                y := add(y, shl(176, mload(add(transcript, 0x180))))
                mstore(add(transcript, 0xdc0), y)
                success := and(validate_ec_point(x, y), success)
            }
            mstore(
                add(transcript, 0xde0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x6e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xe00),
                mulmod(
                    mload(add(transcript, 0xde0)),
                    mload(add(transcript, 0xde0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xe20),
                mulmod(
                    mload(add(transcript, 0xe00)),
                    mload(add(transcript, 0xe00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xe40),
                mulmod(
                    mload(add(transcript, 0xe20)),
                    mload(add(transcript, 0xe20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xe60),
                mulmod(
                    mload(add(transcript, 0xe40)),
                    mload(add(transcript, 0xe40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xe80),
                mulmod(
                    mload(add(transcript, 0xe60)),
                    mload(add(transcript, 0xe60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xea0),
                mulmod(
                    mload(add(transcript, 0xe80)),
                    mload(add(transcript, 0xe80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xec0),
                mulmod(
                    mload(add(transcript, 0xea0)),
                    mload(add(transcript, 0xea0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xee0),
                mulmod(
                    mload(add(transcript, 0xec0)),
                    mload(add(transcript, 0xec0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xf00),
                mulmod(
                    mload(add(transcript, 0xee0)),
                    mload(add(transcript, 0xee0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xf20),
                mulmod(
                    mload(add(transcript, 0xf00)),
                    mload(add(transcript, 0xf00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xf40),
                mulmod(
                    mload(add(transcript, 0xf20)),
                    mload(add(transcript, 0xf20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xf60),
                mulmod(
                    mload(add(transcript, 0xf40)),
                    mload(add(transcript, 0xf40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xf80),
                mulmod(
                    mload(add(transcript, 0xf60)),
                    mload(add(transcript, 0xf60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xfa0),
                mulmod(
                    mload(add(transcript, 0xf80)),
                    mload(add(transcript, 0xf80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xfc0),
                mulmod(
                    mload(add(transcript, 0xfa0)),
                    mload(add(transcript, 0xfa0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0xfe0),
                mulmod(
                    mload(add(transcript, 0xfc0)),
                    mload(add(transcript, 0xfc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1000),
                mulmod(
                    mload(add(transcript, 0xfe0)),
                    mload(add(transcript, 0xfe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1020),
                mulmod(
                    mload(add(transcript, 0x1000)),
                    mload(add(transcript, 0x1000)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1040),
                mulmod(
                    mload(add(transcript, 0x1020)),
                    mload(add(transcript, 0x1020)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1060),
                mulmod(
                    mload(add(transcript, 0x1040)),
                    mload(add(transcript, 0x1040)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1080),
                mulmod(
                    mload(add(transcript, 0x1060)),
                    mload(add(transcript, 0x1060)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x10a0),
                mulmod(
                    mload(add(transcript, 0x1080)),
                    mload(add(transcript, 0x1080)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x10c0),
                mulmod(
                    mload(add(transcript, 0x10a0)),
                    mload(add(transcript, 0x10a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x10e0),
                addmod(
                    mload(add(transcript, 0x10c0)),
                    21888242871839275222246405745257275088548364400416034343698204186575808495616,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1100),
                mulmod(
                    mload(add(transcript, 0x10e0)),
                    21888241567198334088790460357988866238279339518792980768180410072331574733841,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1120),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    12929131318670223636853686797196826072950305380535537217467769528748593133487,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1140),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    8959111553169051585392718948060449015598059019880497126230434657827215362130,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1160),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    14655294445420895451632927078981340937842238432098198055057679026789553137428,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1180),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    7232948426418379770613478666275934150706125968317836288640525159786255358189,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11a0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    12220484078924208264862893648548198807365556694478604924193442790112568454894,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11c0),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    9667758792915066957383512096709076281182807705937429419504761396463240040723,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x11e0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    8734126352828345679573237859165904705806588461301144420590422589042130041188,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1200),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    13154116519010929542673167886091370382741775939114889923107781597533678454429,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1220),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    7358966525675286471217089135633860168646304224547606326237275077574224349359,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1240),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    14529276346163988751029316609623414919902060175868428017460929109001584146258,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1260),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    9741553891420464328295280489650144566903017206473301385034033384879943874347,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1280),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    12146688980418810893951125255607130521645347193942732958664170801695864621270,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12a0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    17329448237240114492580865744088056414251735686965494637158808787419781175510,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12c0),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    4558794634599160729665540001169218674296628713450539706539395399156027320107,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x12e0),
                mulmod(mload(add(transcript, 0x1100)), 1, f_q)
            )
            mstore(
                add(transcript, 0x1300),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    21888242871839275222246405745257275088548364400416034343698204186575808495616,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1320),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    11451405578697956743456240853980216273390554734748796433026540431386972584651,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1340),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    10436837293141318478790164891277058815157809665667237910671663755188835910966,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1360),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    8374374965308410102411073611984011876711565317741801500439755773472076597347,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1380),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    13513867906530865119835332133273263211836799082674232843258448413103731898270,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13a0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    21490807004895109926141140246143262403290679459142140821740925192625185504522,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13c0),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    397435866944165296105265499114012685257684941273893521957278993950622991095,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x13e0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    11211301017135681023579411905410872569206244553457844956874280139879520583390,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1400),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    10676941854703594198666993839846402519342119846958189386823924046696287912227,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1420),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    18846108080730935585192484934247867403156699586319724728525857970312957475341,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1440),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    3042134791108339637053920811009407685391664814096309615172346216262851020276,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1460),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    3615478808282855240548287271348143516886772452944084747768312988864436725401,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1480),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    18272764063556419981698118473909131571661591947471949595929891197711371770216,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14a0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    21451937155080765789602997556105366785934335730087568134349216848800867145453,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14c0),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    436305716758509432643408189151908302614028670328466209348987337774941350164,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x14e0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    1426404432721484388505361748317961535523355871255605456897797744433766488507,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1500),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    20461838439117790833741043996939313553025008529160428886800406442142042007110,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1520),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    13982290267294411190096162596630216412723378687553046594730793425118513274800,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1540),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    7905952604544864032150243148627058675824985712862987748967410761457295220817,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1560),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    216092043779272773661818549620449970334216366264741118684015851799902419467,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1580),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    21672150828060002448584587195636825118214148034151293225014188334775906076150,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15a0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    9537783784440837896026284659246718978615447564543116209283382057778110278482,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15c0),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    12350459087398437326220121086010556109932916835872918134414822128797698217135,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x15e0),
                mulmod(
                    mload(add(transcript, 0x1100)),
                    12619617507853212586156872920672483948819476989779550311307282715684870266992,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1600),
                addmod(
                    mload(add(transcript, 0x6e0)),
                    9268625363986062636089532824584791139728887410636484032390921470890938228625,
                    f_q
                )
            )
            {
                let prod := mload(add(transcript, 0x1140))
                prod := mulmod(mload(add(transcript, 0x1180)), prod, f_q)
                mstore(add(transcript, 0x1620), prod)
                prod := mulmod(mload(add(transcript, 0x11c0)), prod, f_q)
                mstore(add(transcript, 0x1640), prod)
                prod := mulmod(mload(add(transcript, 0x1200)), prod, f_q)
                mstore(add(transcript, 0x1660), prod)
                prod := mulmod(mload(add(transcript, 0x1240)), prod, f_q)
                mstore(add(transcript, 0x1680), prod)
                prod := mulmod(mload(add(transcript, 0x1280)), prod, f_q)
                mstore(add(transcript, 0x16a0), prod)
                prod := mulmod(mload(add(transcript, 0x12c0)), prod, f_q)
                mstore(add(transcript, 0x16c0), prod)
                prod := mulmod(mload(add(transcript, 0x1300)), prod, f_q)
                mstore(add(transcript, 0x16e0), prod)
                prod := mulmod(mload(add(transcript, 0x1340)), prod, f_q)
                mstore(add(transcript, 0x1700), prod)
                prod := mulmod(mload(add(transcript, 0x1380)), prod, f_q)
                mstore(add(transcript, 0x1720), prod)
                prod := mulmod(mload(add(transcript, 0x13c0)), prod, f_q)
                mstore(add(transcript, 0x1740), prod)
                prod := mulmod(mload(add(transcript, 0x1400)), prod, f_q)
                mstore(add(transcript, 0x1760), prod)
                prod := mulmod(mload(add(transcript, 0x1440)), prod, f_q)
                mstore(add(transcript, 0x1780), prod)
                prod := mulmod(mload(add(transcript, 0x1480)), prod, f_q)
                mstore(add(transcript, 0x17a0), prod)
                prod := mulmod(mload(add(transcript, 0x14c0)), prod, f_q)
                mstore(add(transcript, 0x17c0), prod)
                prod := mulmod(mload(add(transcript, 0x1500)), prod, f_q)
                mstore(add(transcript, 0x17e0), prod)
                prod := mulmod(mload(add(transcript, 0x1540)), prod, f_q)
                mstore(add(transcript, 0x1800), prod)
                prod := mulmod(mload(add(transcript, 0x1580)), prod, f_q)
                mstore(add(transcript, 0x1820), prod)
                prod := mulmod(mload(add(transcript, 0x15c0)), prod, f_q)
                mstore(add(transcript, 0x1840), prod)
                prod := mulmod(mload(add(transcript, 0x1600)), prod, f_q)
                mstore(add(transcript, 0x1860), prod)
                prod := mulmod(mload(add(transcript, 0x10e0)), prod, f_q)
                mstore(add(transcript, 0x1880), prod)
            }
            mstore(add(transcript, 0x18c0), 32)
            mstore(add(transcript, 0x18e0), 32)
            mstore(add(transcript, 0x1900), 32)
            mstore(add(transcript, 0x1920), mload(add(transcript, 0x1880)))
            mstore(
                add(transcript, 0x1940),
                21888242871839275222246405745257275088548364400416034343698204186575808495615
            )
            mstore(
                add(transcript, 0x1960),
                21888242871839275222246405745257275088548364400416034343698204186575808495617
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x5,
                        add(transcript, 0x18c0),
                        0xc0,
                        add(transcript, 0x18a0),
                        0x20
                    ),
                    1
                ),
                success
            )
            {
                let inv := mload(add(transcript, 0x18a0))
                let v
                v := mload(add(transcript, 0x10e0))
                mstore(
                    add(transcript, 0x10e0),
                    mulmod(mload(add(transcript, 0x1860)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1600))
                mstore(
                    add(transcript, 0x1600),
                    mulmod(mload(add(transcript, 0x1840)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x15c0))
                mstore(
                    add(transcript, 0x15c0),
                    mulmod(mload(add(transcript, 0x1820)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1580))
                mstore(
                    add(transcript, 0x1580),
                    mulmod(mload(add(transcript, 0x1800)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1540))
                mstore(
                    add(transcript, 0x1540),
                    mulmod(mload(add(transcript, 0x17e0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1500))
                mstore(
                    add(transcript, 0x1500),
                    mulmod(mload(add(transcript, 0x17c0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x14c0))
                mstore(
                    add(transcript, 0x14c0),
                    mulmod(mload(add(transcript, 0x17a0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1480))
                mstore(
                    add(transcript, 0x1480),
                    mulmod(mload(add(transcript, 0x1780)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1440))
                mstore(
                    add(transcript, 0x1440),
                    mulmod(mload(add(transcript, 0x1760)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1400))
                mstore(
                    add(transcript, 0x1400),
                    mulmod(mload(add(transcript, 0x1740)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x13c0))
                mstore(
                    add(transcript, 0x13c0),
                    mulmod(mload(add(transcript, 0x1720)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1380))
                mstore(
                    add(transcript, 0x1380),
                    mulmod(mload(add(transcript, 0x1700)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1340))
                mstore(
                    add(transcript, 0x1340),
                    mulmod(mload(add(transcript, 0x16e0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1300))
                mstore(
                    add(transcript, 0x1300),
                    mulmod(mload(add(transcript, 0x16c0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x12c0))
                mstore(
                    add(transcript, 0x12c0),
                    mulmod(mload(add(transcript, 0x16a0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1280))
                mstore(
                    add(transcript, 0x1280),
                    mulmod(mload(add(transcript, 0x1680)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1240))
                mstore(
                    add(transcript, 0x1240),
                    mulmod(mload(add(transcript, 0x1660)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1200))
                mstore(
                    add(transcript, 0x1200),
                    mulmod(mload(add(transcript, 0x1640)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x11c0))
                mstore(
                    add(transcript, 0x11c0),
                    mulmod(mload(add(transcript, 0x1620)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x1180))
                mstore(
                    add(transcript, 0x1180),
                    mulmod(mload(add(transcript, 0x1140)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                mstore(add(transcript, 0x1140), inv)
            }
            mstore(
                add(transcript, 0x1980),
                mulmod(
                    mload(add(transcript, 0x1120)),
                    mload(add(transcript, 0x1140)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x19a0),
                mulmod(
                    mload(add(transcript, 0x1160)),
                    mload(add(transcript, 0x1180)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x19c0),
                mulmod(
                    mload(add(transcript, 0x11a0)),
                    mload(add(transcript, 0x11c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x19e0),
                mulmod(
                    mload(add(transcript, 0x11e0)),
                    mload(add(transcript, 0x1200)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1a00),
                mulmod(
                    mload(add(transcript, 0x1220)),
                    mload(add(transcript, 0x1240)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1a20),
                mulmod(
                    mload(add(transcript, 0x1260)),
                    mload(add(transcript, 0x1280)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1a40),
                mulmod(
                    mload(add(transcript, 0x12a0)),
                    mload(add(transcript, 0x12c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1a60),
                mulmod(
                    mload(add(transcript, 0x12e0)),
                    mload(add(transcript, 0x1300)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1a80),
                mulmod(
                    mload(add(transcript, 0x1320)),
                    mload(add(transcript, 0x1340)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1aa0),
                mulmod(
                    mload(add(transcript, 0x1360)),
                    mload(add(transcript, 0x1380)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ac0),
                mulmod(
                    mload(add(transcript, 0x13a0)),
                    mload(add(transcript, 0x13c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ae0),
                mulmod(
                    mload(add(transcript, 0x13e0)),
                    mload(add(transcript, 0x1400)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1b00),
                mulmod(
                    mload(add(transcript, 0x1420)),
                    mload(add(transcript, 0x1440)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1b20),
                mulmod(
                    mload(add(transcript, 0x1460)),
                    mload(add(transcript, 0x1480)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1b40),
                mulmod(
                    mload(add(transcript, 0x14a0)),
                    mload(add(transcript, 0x14c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1b60),
                mulmod(
                    mload(add(transcript, 0x14e0)),
                    mload(add(transcript, 0x1500)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1b80),
                mulmod(
                    mload(add(transcript, 0x1520)),
                    mload(add(transcript, 0x1540)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ba0),
                mulmod(
                    mload(add(transcript, 0x1560)),
                    mload(add(transcript, 0x1580)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1bc0),
                mulmod(
                    mload(add(transcript, 0x15a0)),
                    mload(add(transcript, 0x15c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1be0),
                mulmod(
                    mload(add(transcript, 0x15e0)),
                    mload(add(transcript, 0x1600)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x1a60)),
                    mload(add(transcript, 0x20)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1a80)),
                        mload(add(transcript, 0x40)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1aa0)),
                        mload(add(transcript, 0x60)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ac0)),
                        mload(add(transcript, 0x80)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ae0)),
                        mload(add(transcript, 0xa0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1b00)),
                        mload(add(transcript, 0xc0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1b20)),
                        mload(add(transcript, 0xe0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1b40)),
                        mload(add(transcript, 0x100)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1b60)),
                        mload(add(transcript, 0x120)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1b80)),
                        mload(add(transcript, 0x140)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1ba0)),
                        mload(add(transcript, 0x160)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1bc0)),
                        mload(add(transcript, 0x180)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x1be0)),
                        mload(add(transcript, 0x1a0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x1c00), result)
            }
            mstore(
                add(transcript, 0x1c20),
                addmod(2, sub(f_q, mload(add(transcript, 0x900))), f_q)
            )
            mstore(
                add(transcript, 0x1c40),
                mulmod(
                    mload(add(transcript, 0x1c20)),
                    mload(add(transcript, 0x900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1c60),
                mulmod(
                    mload(add(transcript, 0x760)),
                    mload(add(transcript, 0x740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1c80),
                addmod(
                    mload(add(transcript, 0x720)),
                    mload(add(transcript, 0x1c60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ca0),
                addmod(
                    mload(add(transcript, 0x1c80)),
                    sub(f_q, mload(add(transcript, 0x780))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1cc0),
                mulmod(
                    mload(add(transcript, 0x1ca0)),
                    mload(add(transcript, 0x1c40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ce0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x1cc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d00),
                mulmod(
                    mload(add(transcript, 0x7e0)),
                    mload(add(transcript, 0x7c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d20),
                addmod(
                    mload(add(transcript, 0x7a0)),
                    mload(add(transcript, 0x1d00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d40),
                addmod(
                    mload(add(transcript, 0x1d20)),
                    sub(f_q, mload(add(transcript, 0x800))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d60),
                mulmod(
                    mload(add(transcript, 0x1d40)),
                    mload(add(transcript, 0x920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1d80),
                addmod(
                    mload(add(transcript, 0x1ce0)),
                    mload(add(transcript, 0x1d60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1da0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x1d80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1dc0),
                addmod(1, sub(f_q, mload(add(transcript, 0x900))), f_q)
            )
            mstore(
                add(transcript, 0x1de0),
                mulmod(
                    mload(add(transcript, 0x1dc0)),
                    mload(add(transcript, 0x900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e00),
                mulmod(
                    mload(add(transcript, 0x860)),
                    mload(add(transcript, 0x840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e20),
                addmod(
                    mload(add(transcript, 0x820)),
                    mload(add(transcript, 0x1e00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e40),
                addmod(
                    mload(add(transcript, 0x1e20)),
                    sub(f_q, mload(add(transcript, 0x880))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e60),
                mulmod(
                    mload(add(transcript, 0x1e40)),
                    mload(add(transcript, 0x1de0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1e80),
                addmod(
                    mload(add(transcript, 0x1da0)),
                    mload(add(transcript, 0x1e60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ea0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x1e80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1ec0),
                addmod(1, sub(f_q, mload(add(transcript, 0xa20))), f_q)
            )
            mstore(
                add(transcript, 0x1ee0),
                mulmod(
                    mload(add(transcript, 0x1ec0)),
                    mload(add(transcript, 0x1a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f00),
                addmod(
                    mload(add(transcript, 0x1ea0)),
                    mload(add(transcript, 0x1ee0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f20),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x1f00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f40),
                mulmod(
                    mload(add(transcript, 0xae0)),
                    mload(add(transcript, 0xae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f60),
                addmod(
                    mload(add(transcript, 0x1f40)),
                    sub(f_q, mload(add(transcript, 0xae0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1f80),
                mulmod(
                    mload(add(transcript, 0x1f60)),
                    mload(add(transcript, 0x1980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1fa0),
                addmod(
                    mload(add(transcript, 0x1f20)),
                    mload(add(transcript, 0x1f80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1fc0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x1fa0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x1fe0),
                addmod(
                    mload(add(transcript, 0xa80)),
                    sub(f_q, mload(add(transcript, 0xa60))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2000),
                mulmod(
                    mload(add(transcript, 0x1fe0)),
                    mload(add(transcript, 0x1a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2020),
                addmod(
                    mload(add(transcript, 0x1fc0)),
                    mload(add(transcript, 0x2000)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2040),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2020)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2060),
                addmod(
                    mload(add(transcript, 0xae0)),
                    sub(f_q, mload(add(transcript, 0xac0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2080),
                mulmod(
                    mload(add(transcript, 0x2060)),
                    mload(add(transcript, 0x1a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x20a0),
                addmod(
                    mload(add(transcript, 0x2040)),
                    mload(add(transcript, 0x2080)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x20c0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x20a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x20e0),
                addmod(1, sub(f_q, mload(add(transcript, 0x1980))), f_q)
            )
            mstore(
                add(transcript, 0x2100),
                addmod(
                    mload(add(transcript, 0x19a0)),
                    mload(add(transcript, 0x19c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2120),
                addmod(
                    mload(add(transcript, 0x2100)),
                    mload(add(transcript, 0x19e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2140),
                addmod(
                    mload(add(transcript, 0x2120)),
                    mload(add(transcript, 0x1a00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2160),
                addmod(
                    mload(add(transcript, 0x2140)),
                    mload(add(transcript, 0x1a20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2180),
                addmod(
                    mload(add(transcript, 0x2160)),
                    mload(add(transcript, 0x1a40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x21a0),
                addmod(
                    mload(add(transcript, 0x20e0)),
                    sub(f_q, mload(add(transcript, 0x2180))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x21c0),
                mulmod(
                    mload(add(transcript, 0x960)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x21e0),
                addmod(
                    mload(add(transcript, 0x8c0)),
                    mload(add(transcript, 0x21c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2200),
                addmod(
                    mload(add(transcript, 0x21e0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2220),
                mulmod(
                    mload(add(transcript, 0x980)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2240),
                addmod(
                    mload(add(transcript, 0x720)),
                    mload(add(transcript, 0x2220)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2260),
                addmod(
                    mload(add(transcript, 0x2240)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2280),
                mulmod(
                    mload(add(transcript, 0x2260)),
                    mload(add(transcript, 0x2200)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x22a0),
                mulmod(
                    mload(add(transcript, 0x2280)),
                    mload(add(transcript, 0xa40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x22c0),
                mulmod(1, mload(add(transcript, 0x3c0)), f_q)
            )
            mstore(
                add(transcript, 0x22e0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x22c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2300),
                addmod(
                    mload(add(transcript, 0x8c0)),
                    mload(add(transcript, 0x22e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2320),
                addmod(
                    mload(add(transcript, 0x2300)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2340),
                mulmod(
                    4131629893567559867359510883348571134090853742863529169391034518566172092834,
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2360),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x2340)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2380),
                addmod(
                    mload(add(transcript, 0x720)),
                    mload(add(transcript, 0x2360)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23a0),
                addmod(
                    mload(add(transcript, 0x2380)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23c0),
                mulmod(
                    mload(add(transcript, 0x23a0)),
                    mload(add(transcript, 0x2320)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x23e0),
                mulmod(
                    mload(add(transcript, 0x23c0)),
                    mload(add(transcript, 0xa20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2400),
                addmod(
                    mload(add(transcript, 0x22a0)),
                    sub(f_q, mload(add(transcript, 0x23e0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2420),
                mulmod(
                    mload(add(transcript, 0x2400)),
                    mload(add(transcript, 0x21a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2440),
                addmod(
                    mload(add(transcript, 0x20c0)),
                    mload(add(transcript, 0x2420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2460),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2440)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2480),
                mulmod(
                    mload(add(transcript, 0x9a0)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x24a0),
                addmod(
                    mload(add(transcript, 0x7a0)),
                    mload(add(transcript, 0x2480)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x24c0),
                addmod(
                    mload(add(transcript, 0x24a0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x24e0),
                mulmod(
                    mload(add(transcript, 0x9c0)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2500),
                addmod(
                    mload(add(transcript, 0x820)),
                    mload(add(transcript, 0x24e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2520),
                addmod(
                    mload(add(transcript, 0x2500)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2540),
                mulmod(
                    mload(add(transcript, 0x2520)),
                    mload(add(transcript, 0x24c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2560),
                mulmod(
                    mload(add(transcript, 0x2540)),
                    mload(add(transcript, 0xaa0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2580),
                mulmod(
                    8910878055287538404433155982483128285667088683464058436815641868457422632747,
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25a0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x2580)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25c0),
                addmod(
                    mload(add(transcript, 0x7a0)),
                    mload(add(transcript, 0x25a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x25e0),
                addmod(
                    mload(add(transcript, 0x25c0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2600),
                mulmod(
                    11166246659983828508719468090013646171463329086121580628794302409516816350802,
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2620),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x2600)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2640),
                addmod(
                    mload(add(transcript, 0x820)),
                    mload(add(transcript, 0x2620)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2660),
                addmod(
                    mload(add(transcript, 0x2640)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2680),
                mulmod(
                    mload(add(transcript, 0x2660)),
                    mload(add(transcript, 0x25e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26a0),
                mulmod(
                    mload(add(transcript, 0x2680)),
                    mload(add(transcript, 0xa80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26c0),
                addmod(
                    mload(add(transcript, 0x2560)),
                    sub(f_q, mload(add(transcript, 0x26a0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x26e0),
                mulmod(
                    mload(add(transcript, 0x26c0)),
                    mload(add(transcript, 0x21a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2700),
                addmod(
                    mload(add(transcript, 0x2460)),
                    mload(add(transcript, 0x26e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2720),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2700)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2740),
                mulmod(
                    mload(add(transcript, 0x9e0)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2760),
                addmod(
                    mload(add(transcript, 0x8a0)),
                    mload(add(transcript, 0x2740)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2780),
                addmod(
                    mload(add(transcript, 0x2760)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27a0),
                mulmod(
                    mload(add(transcript, 0xa00)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27c0),
                addmod(
                    mload(add(transcript, 0x1c00)),
                    mload(add(transcript, 0x27a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x27e0),
                addmod(
                    mload(add(transcript, 0x27c0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2800),
                mulmod(
                    mload(add(transcript, 0x27e0)),
                    mload(add(transcript, 0x2780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2820),
                mulmod(
                    mload(add(transcript, 0x2800)),
                    mload(add(transcript, 0xb00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2840),
                mulmod(
                    284840088355319032285349970403338060113257071685626700086398481893096618818,
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2860),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x2840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2880),
                addmod(
                    mload(add(transcript, 0x8a0)),
                    mload(add(transcript, 0x2860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28a0),
                addmod(
                    mload(add(transcript, 0x2880)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28c0),
                mulmod(
                    21134065618345176623193549882539580312263652408302468683943992798037078993309,
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x28e0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    mload(add(transcript, 0x28c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2900),
                addmod(
                    mload(add(transcript, 0x1c00)),
                    mload(add(transcript, 0x28e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2920),
                addmod(
                    mload(add(transcript, 0x2900)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2940),
                mulmod(
                    mload(add(transcript, 0x2920)),
                    mload(add(transcript, 0x28a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2960),
                mulmod(
                    mload(add(transcript, 0x2940)),
                    mload(add(transcript, 0xae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2980),
                addmod(
                    mload(add(transcript, 0x2820)),
                    sub(f_q, mload(add(transcript, 0x2960))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29a0),
                mulmod(
                    mload(add(transcript, 0x2980)),
                    mload(add(transcript, 0x21a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29c0),
                addmod(
                    mload(add(transcript, 0x2720)),
                    mload(add(transcript, 0x29a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x29e0),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x29c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a00),
                addmod(1, sub(f_q, mload(add(transcript, 0xb20))), f_q)
            )
            mstore(
                add(transcript, 0x2a20),
                mulmod(
                    mload(add(transcript, 0x2a00)),
                    mload(add(transcript, 0x1a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a40),
                addmod(
                    mload(add(transcript, 0x29e0)),
                    mload(add(transcript, 0x2a20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a60),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2a40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2a80),
                mulmod(
                    mload(add(transcript, 0xb20)),
                    mload(add(transcript, 0xb20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2aa0),
                addmod(
                    mload(add(transcript, 0x2a80)),
                    sub(f_q, mload(add(transcript, 0xb20))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ac0),
                mulmod(
                    mload(add(transcript, 0x2aa0)),
                    mload(add(transcript, 0x1980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ae0),
                addmod(
                    mload(add(transcript, 0x2a60)),
                    mload(add(transcript, 0x2ac0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b00),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2ae0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b20),
                addmod(
                    mload(add(transcript, 0xb60)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b40),
                mulmod(
                    mload(add(transcript, 0x2b20)),
                    mload(add(transcript, 0xb40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b60),
                addmod(
                    mload(add(transcript, 0xba0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2b80),
                mulmod(
                    mload(add(transcript, 0x2b60)),
                    mload(add(transcript, 0x2b40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ba0),
                addmod(
                    mload(add(transcript, 0x8a0)),
                    mload(add(transcript, 0x3c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2bc0),
                mulmod(
                    mload(add(transcript, 0x2ba0)),
                    mload(add(transcript, 0xb20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2be0),
                addmod(
                    mload(add(transcript, 0x8e0)),
                    mload(add(transcript, 0x420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c00),
                mulmod(
                    mload(add(transcript, 0x2be0)),
                    mload(add(transcript, 0x2bc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c20),
                addmod(
                    mload(add(transcript, 0x2b80)),
                    sub(f_q, mload(add(transcript, 0x2c00))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c40),
                mulmod(
                    mload(add(transcript, 0x2c20)),
                    mload(add(transcript, 0x21a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c60),
                addmod(
                    mload(add(transcript, 0x2b00)),
                    mload(add(transcript, 0x2c40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2c80),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2c60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ca0),
                addmod(
                    mload(add(transcript, 0xb60)),
                    sub(f_q, mload(add(transcript, 0xba0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2cc0),
                mulmod(
                    mload(add(transcript, 0x2ca0)),
                    mload(add(transcript, 0x1a60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ce0),
                addmod(
                    mload(add(transcript, 0x2c80)),
                    mload(add(transcript, 0x2cc0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d00),
                mulmod(
                    mload(add(transcript, 0x5c0)),
                    mload(add(transcript, 0x2ce0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d20),
                mulmod(
                    mload(add(transcript, 0x2ca0)),
                    mload(add(transcript, 0x21a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d40),
                addmod(
                    mload(add(transcript, 0xb60)),
                    sub(f_q, mload(add(transcript, 0xb80))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d60),
                mulmod(
                    mload(add(transcript, 0x2d40)),
                    mload(add(transcript, 0x2d20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2d80),
                addmod(
                    mload(add(transcript, 0x2d00)),
                    mload(add(transcript, 0x2d60)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2da0),
                mulmod(
                    mload(add(transcript, 0x10c0)),
                    mload(add(transcript, 0x10c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2dc0),
                mulmod(
                    mload(add(transcript, 0x2da0)),
                    mload(add(transcript, 0x10c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2de0),
                mulmod(1, mload(add(transcript, 0x10c0)), f_q)
            )
            mstore(
                add(transcript, 0x2e00),
                mulmod(1, mload(add(transcript, 0x2da0)), f_q)
            )
            mstore(
                add(transcript, 0x2e20),
                mulmod(
                    mload(add(transcript, 0x2d80)),
                    mload(add(transcript, 0x10e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e40),
                mulmod(
                    mload(add(transcript, 0xde0)),
                    mload(add(transcript, 0x6e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2e60),
                mulmod(mload(add(transcript, 0x6e0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x2e80),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2e60))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ea0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    8374374965308410102411073611984011876711565317741801500439755773472076597347,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ec0),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2ea0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2ee0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    11451405578697956743456240853980216273390554734748796433026540431386972584651,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f00),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2ee0))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f20),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    12929131318670223636853686797196826072950305380535537217467769528748593133487,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f40),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2f20))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f60),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    17329448237240114492580865744088056414251735686965494637158808787419781175510,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2f80),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2f60))),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2fa0),
                mulmod(
                    mload(add(transcript, 0x6e0)),
                    21490807004895109926141140246143262403290679459142140821740925192625185504522,
                    f_q
                )
            )
            mstore(
                add(transcript, 0x2fc0),
                addmod(
                    mload(add(transcript, 0xce0)),
                    sub(f_q, mload(add(transcript, 0x2fa0))),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    6616149745577394522356295102346368305374051634342887004165528916468992151333,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        15272093126261880699890110642910906783174312766073147339532675270106816344284,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x2fe0), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    530501691302793820034524283154921640443166880847115433758691660016816186416,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        6735468303947967792722299167169712601265763928443086612877978228369959138708,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3000), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    6735468303947967792722299167169712601265763928443086612877978228369959138708,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        21402573809525492531235934453699988060841876665026314791644170130242704768864,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3020), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    21558793644302942916864965630979640748886316167261336210841195936026980690666,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        21647881284526053590463969745634050372655996593461286860577821962674562513632,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3040), result)
            }
            mstore(
                add(transcript, 0x3060),
                mulmod(1, mload(add(transcript, 0x2e80)), f_q)
            )
            mstore(
                add(transcript, 0x3080),
                mulmod(
                    mload(add(transcript, 0x3060)),
                    mload(add(transcript, 0x2f00)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x30a0),
                mulmod(
                    mload(add(transcript, 0x3080)),
                    mload(add(transcript, 0x2ec0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x30c0),
                mulmod(
                    mload(add(transcript, 0x30a0)),
                    mload(add(transcript, 0x2fc0)),
                    f_q
                )
            )
            {
                let result := mulmod(mload(add(transcript, 0xce0)), 1, f_q)
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        21888242871839275222246405745257275088548364400416034343698204186575808495616,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x30e0), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    12163000419891990293569405173061573680049742717229898748261573253229795914908,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        9725242451947284928677000572195701408498621683186135595436630933346012580709,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3100), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    17085049131699056766421998221476555826977441931846378573521510030619952504372,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        6337000465755888211746305680664882431492568521396101891532798530745714905908,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3120), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    10262058425268217215884133263876699099081481632544093361167483234163265012860,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        14297308348282218433797077139696728813764374573836158179437870281950912384055,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3140), result)
            }
            mstore(
                add(transcript, 0x3160),
                mulmod(
                    mload(add(transcript, 0x3080)),
                    mload(add(transcript, 0x2f40)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    10436837293141318478790164891277058815157809665667237910671663755188835910967,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        11451405578697956743456240853980216273390554734748796433026540431386972584650,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3180), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    11451405578697956743456240853980216273390554734748796433026540431386972584650,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        3077030613389546641045167241996204396678989417006994932586784657914895987304,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x31a0), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    4558794634599160729665540001169218674296628713450539706539395399156027320108,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        17329448237240114492580865744088056414251735686965494637158808787419781175509,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x31c0), result)
            }
            {
                let result := mulmod(
                    mload(add(transcript, 0xce0)),
                    17329448237240114492580865744088056414251735686965494637158808787419781175509,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x6e0)),
                        7587894345819650164285585254437911847348718480492193252124775402539837301163,
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x31e0), result)
            }
            mstore(
                add(transcript, 0x3200),
                mulmod(
                    mload(add(transcript, 0x3060)),
                    mload(add(transcript, 0x2f80)),
                    f_q
                )
            )
            {
                let prod := mload(add(transcript, 0x2fe0))
                prod := mulmod(mload(add(transcript, 0x3000)), prod, f_q)
                mstore(add(transcript, 0x3220), prod)
                prod := mulmod(mload(add(transcript, 0x3020)), prod, f_q)
                mstore(add(transcript, 0x3240), prod)
                prod := mulmod(mload(add(transcript, 0x3040)), prod, f_q)
                mstore(add(transcript, 0x3260), prod)
                prod := mulmod(mload(add(transcript, 0x30e0)), prod, f_q)
                mstore(add(transcript, 0x3280), prod)
                prod := mulmod(mload(add(transcript, 0x3060)), prod, f_q)
                mstore(add(transcript, 0x32a0), prod)
                prod := mulmod(mload(add(transcript, 0x3100)), prod, f_q)
                mstore(add(transcript, 0x32c0), prod)
                prod := mulmod(mload(add(transcript, 0x3120)), prod, f_q)
                mstore(add(transcript, 0x32e0), prod)
                prod := mulmod(mload(add(transcript, 0x3140)), prod, f_q)
                mstore(add(transcript, 0x3300), prod)
                prod := mulmod(mload(add(transcript, 0x3160)), prod, f_q)
                mstore(add(transcript, 0x3320), prod)
                prod := mulmod(mload(add(transcript, 0x3180)), prod, f_q)
                mstore(add(transcript, 0x3340), prod)
                prod := mulmod(mload(add(transcript, 0x31a0)), prod, f_q)
                mstore(add(transcript, 0x3360), prod)
                prod := mulmod(mload(add(transcript, 0x3080)), prod, f_q)
                mstore(add(transcript, 0x3380), prod)
                prod := mulmod(mload(add(transcript, 0x31c0)), prod, f_q)
                mstore(add(transcript, 0x33a0), prod)
                prod := mulmod(mload(add(transcript, 0x31e0)), prod, f_q)
                mstore(add(transcript, 0x33c0), prod)
                prod := mulmod(mload(add(transcript, 0x3200)), prod, f_q)
                mstore(add(transcript, 0x33e0), prod)
            }
            mstore(add(transcript, 0x3420), 32)
            mstore(add(transcript, 0x3440), 32)
            mstore(add(transcript, 0x3460), 32)
            mstore(add(transcript, 0x3480), mload(add(transcript, 0x33e0)))
            mstore(
                add(transcript, 0x34a0),
                21888242871839275222246405745257275088548364400416034343698204186575808495615
            )
            mstore(
                add(transcript, 0x34c0),
                21888242871839275222246405745257275088548364400416034343698204186575808495617
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x5,
                        add(transcript, 0x3420),
                        0xc0,
                        add(transcript, 0x3400),
                        0x20
                    ),
                    1
                ),
                success
            )
            {
                let inv := mload(add(transcript, 0x3400))
                let v
                v := mload(add(transcript, 0x3200))
                mstore(
                    add(transcript, 0x3200),
                    mulmod(mload(add(transcript, 0x33c0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x31e0))
                mstore(
                    add(transcript, 0x31e0),
                    mulmod(mload(add(transcript, 0x33a0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x31c0))
                mstore(
                    add(transcript, 0x31c0),
                    mulmod(mload(add(transcript, 0x3380)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3080))
                mstore(
                    add(transcript, 0x3080),
                    mulmod(mload(add(transcript, 0x3360)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x31a0))
                mstore(
                    add(transcript, 0x31a0),
                    mulmod(mload(add(transcript, 0x3340)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3180))
                mstore(
                    add(transcript, 0x3180),
                    mulmod(mload(add(transcript, 0x3320)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3160))
                mstore(
                    add(transcript, 0x3160),
                    mulmod(mload(add(transcript, 0x3300)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3140))
                mstore(
                    add(transcript, 0x3140),
                    mulmod(mload(add(transcript, 0x32e0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3120))
                mstore(
                    add(transcript, 0x3120),
                    mulmod(mload(add(transcript, 0x32c0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3100))
                mstore(
                    add(transcript, 0x3100),
                    mulmod(mload(add(transcript, 0x32a0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3060))
                mstore(
                    add(transcript, 0x3060),
                    mulmod(mload(add(transcript, 0x3280)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x30e0))
                mstore(
                    add(transcript, 0x30e0),
                    mulmod(mload(add(transcript, 0x3260)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3040))
                mstore(
                    add(transcript, 0x3040),
                    mulmod(mload(add(transcript, 0x3240)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3020))
                mstore(
                    add(transcript, 0x3020),
                    mulmod(mload(add(transcript, 0x3220)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3000))
                mstore(
                    add(transcript, 0x3000),
                    mulmod(mload(add(transcript, 0x2fe0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                mstore(add(transcript, 0x2fe0), inv)
            }
            {
                let result := mload(add(transcript, 0x2fe0))
                result := addmod(mload(add(transcript, 0x3000)), result, f_q)
                result := addmod(mload(add(transcript, 0x3020)), result, f_q)
                result := addmod(mload(add(transcript, 0x3040)), result, f_q)
                mstore(add(transcript, 0x34e0), result)
            }
            mstore(
                add(transcript, 0x3500),
                mulmod(
                    mload(add(transcript, 0x30c0)),
                    mload(add(transcript, 0x3060)),
                    f_q
                )
            )
            {
                let result := mload(add(transcript, 0x30e0))
                mstore(add(transcript, 0x3520), result)
            }
            mstore(
                add(transcript, 0x3540),
                mulmod(
                    mload(add(transcript, 0x30c0)),
                    mload(add(transcript, 0x3160)),
                    f_q
                )
            )
            {
                let result := mload(add(transcript, 0x3100))
                result := addmod(mload(add(transcript, 0x3120)), result, f_q)
                result := addmod(mload(add(transcript, 0x3140)), result, f_q)
                mstore(add(transcript, 0x3560), result)
            }
            mstore(
                add(transcript, 0x3580),
                mulmod(
                    mload(add(transcript, 0x30c0)),
                    mload(add(transcript, 0x3080)),
                    f_q
                )
            )
            {
                let result := mload(add(transcript, 0x3180))
                result := addmod(mload(add(transcript, 0x31a0)), result, f_q)
                mstore(add(transcript, 0x35a0), result)
            }
            mstore(
                add(transcript, 0x35c0),
                mulmod(
                    mload(add(transcript, 0x30c0)),
                    mload(add(transcript, 0x3200)),
                    f_q
                )
            )
            {
                let result := mload(add(transcript, 0x31c0))
                result := addmod(mload(add(transcript, 0x31e0)), result, f_q)
                mstore(add(transcript, 0x35e0), result)
            }
            {
                let prod := mload(add(transcript, 0x34e0))
                prod := mulmod(mload(add(transcript, 0x3520)), prod, f_q)
                mstore(add(transcript, 0x3600), prod)
                prod := mulmod(mload(add(transcript, 0x3560)), prod, f_q)
                mstore(add(transcript, 0x3620), prod)
                prod := mulmod(mload(add(transcript, 0x35a0)), prod, f_q)
                mstore(add(transcript, 0x3640), prod)
                prod := mulmod(mload(add(transcript, 0x35e0)), prod, f_q)
                mstore(add(transcript, 0x3660), prod)
            }
            mstore(add(transcript, 0x36a0), 32)
            mstore(add(transcript, 0x36c0), 32)
            mstore(add(transcript, 0x36e0), 32)
            mstore(add(transcript, 0x3700), mload(add(transcript, 0x3660)))
            mstore(
                add(transcript, 0x3720),
                21888242871839275222246405745257275088548364400416034343698204186575808495615
            )
            mstore(
                add(transcript, 0x3740),
                21888242871839275222246405745257275088548364400416034343698204186575808495617
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x5,
                        add(transcript, 0x36a0),
                        0xc0,
                        add(transcript, 0x3680),
                        0x20
                    ),
                    1
                ),
                success
            )
            {
                let inv := mload(add(transcript, 0x3680))
                let v
                v := mload(add(transcript, 0x35e0))
                mstore(
                    add(transcript, 0x35e0),
                    mulmod(mload(add(transcript, 0x3640)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x35a0))
                mstore(
                    add(transcript, 0x35a0),
                    mulmod(mload(add(transcript, 0x3620)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3560))
                mstore(
                    add(transcript, 0x3560),
                    mulmod(mload(add(transcript, 0x3600)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                v := mload(add(transcript, 0x3520))
                mstore(
                    add(transcript, 0x3520),
                    mulmod(mload(add(transcript, 0x34e0)), inv, f_q)
                )
                inv := mulmod(v, inv, f_q)
                mstore(add(transcript, 0x34e0), inv)
            }
            mstore(
                add(transcript, 0x3760),
                mulmod(
                    mload(add(transcript, 0x3500)),
                    mload(add(transcript, 0x3520)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3780),
                mulmod(
                    mload(add(transcript, 0x3540)),
                    mload(add(transcript, 0x3560)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37a0),
                mulmod(
                    mload(add(transcript, 0x3580)),
                    mload(add(transcript, 0x35a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37c0),
                mulmod(
                    mload(add(transcript, 0x35c0)),
                    mload(add(transcript, 0x35e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x37e0),
                mulmod(
                    mload(add(transcript, 0xbe0)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3800),
                mulmod(
                    mload(add(transcript, 0x37e0)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3820),
                mulmod(
                    mload(add(transcript, 0x3800)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3840),
                mulmod(
                    mload(add(transcript, 0x3820)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3860),
                mulmod(
                    mload(add(transcript, 0x3840)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3880),
                mulmod(
                    mload(add(transcript, 0x3860)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38a0),
                mulmod(
                    mload(add(transcript, 0x3880)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38c0),
                mulmod(
                    mload(add(transcript, 0x38a0)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x38e0),
                mulmod(
                    mload(add(transcript, 0x38c0)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3900),
                mulmod(
                    mload(add(transcript, 0x38e0)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3920),
                mulmod(
                    mload(add(transcript, 0x3900)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3940),
                mulmod(
                    mload(add(transcript, 0x3920)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3960),
                mulmod(
                    mload(add(transcript, 0x3940)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3980),
                mulmod(
                    mload(add(transcript, 0xc40)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39a0),
                mulmod(
                    mload(add(transcript, 0x3980)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39c0),
                mulmod(
                    mload(add(transcript, 0x39a0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x39e0),
                mulmod(
                    mload(add(transcript, 0x39c0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x720)),
                    mload(add(transcript, 0x2fe0)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x740)),
                        mload(add(transcript, 0x3000)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x760)),
                        mload(add(transcript, 0x3020)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x780)),
                        mload(add(transcript, 0x3040)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3a00), result)
            }
            mstore(
                add(transcript, 0x3a20),
                mulmod(
                    mload(add(transcript, 0x3a00)),
                    mload(add(transcript, 0x34e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3a40),
                mulmod(sub(f_q, mload(add(transcript, 0x3a20))), 1, f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x7a0)),
                    mload(add(transcript, 0x2fe0)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x7c0)),
                        mload(add(transcript, 0x3000)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x7e0)),
                        mload(add(transcript, 0x3020)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x800)),
                        mload(add(transcript, 0x3040)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3a60), result)
            }
            mstore(
                add(transcript, 0x3a80),
                mulmod(
                    mload(add(transcript, 0x3a60)),
                    mload(add(transcript, 0x34e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3aa0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3a80))),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ac0),
                mulmod(1, mload(add(transcript, 0xbe0)), f_q)
            )
            mstore(
                add(transcript, 0x3ae0),
                addmod(
                    mload(add(transcript, 0x3a40)),
                    mload(add(transcript, 0x3aa0)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x820)),
                    mload(add(transcript, 0x2fe0)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x840)),
                        mload(add(transcript, 0x3000)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x860)),
                        mload(add(transcript, 0x3020)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0x880)),
                        mload(add(transcript, 0x3040)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x3b00), result)
            }
            mstore(
                add(transcript, 0x3b20),
                mulmod(
                    mload(add(transcript, 0x3b00)),
                    mload(add(transcript, 0x34e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b40),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3b20))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3b60),
                mulmod(1, mload(add(transcript, 0x37e0)), f_q)
            )
            mstore(
                add(transcript, 0x3b80),
                addmod(
                    mload(add(transcript, 0x3ae0)),
                    mload(add(transcript, 0x3b40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ba0),
                mulmod(mload(add(transcript, 0x3b80)), 1, f_q)
            )
            mstore(
                add(transcript, 0x3bc0),
                mulmod(mload(add(transcript, 0x3ac0)), 1, f_q)
            )
            mstore(
                add(transcript, 0x3be0),
                mulmod(mload(add(transcript, 0x3b60)), 1, f_q)
            )
            mstore(
                add(transcript, 0x3c00),
                mulmod(1, mload(add(transcript, 0x3500)), f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x8a0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3c20), result)
            }
            mstore(
                add(transcript, 0x3c40),
                mulmod(
                    mload(add(transcript, 0x3c20)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3c60),
                mulmod(sub(f_q, mload(add(transcript, 0x3c40))), 1, f_q)
            )
            mstore(
                add(transcript, 0x3c80),
                mulmod(mload(add(transcript, 0x3c00)), 1, f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xba0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3ca0), result)
            }
            mstore(
                add(transcript, 0x3cc0),
                mulmod(
                    mload(add(transcript, 0x3ca0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ce0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3cc0))),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d00),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d20),
                addmod(
                    mload(add(transcript, 0x3c60)),
                    mload(add(transcript, 0x3ce0)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x8c0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3d40), result)
            }
            mstore(
                add(transcript, 0x3d60),
                mulmod(
                    mload(add(transcript, 0x3d40)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3d80),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3d60))),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3da0),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x37e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3dc0),
                addmod(
                    mload(add(transcript, 0x3d20)),
                    mload(add(transcript, 0x3d80)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x8e0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3de0), result)
            }
            mstore(
                add(transcript, 0x3e00),
                mulmod(
                    mload(add(transcript, 0x3de0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3e00))),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e40),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3800)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3e60),
                addmod(
                    mload(add(transcript, 0x3dc0)),
                    mload(add(transcript, 0x3e20)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x900)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3e80), result)
            }
            mstore(
                add(transcript, 0x3ea0),
                mulmod(
                    mload(add(transcript, 0x3e80)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ec0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3ea0))),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3ee0),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3820)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f00),
                addmod(
                    mload(add(transcript, 0x3e60)),
                    mload(add(transcript, 0x3ec0)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x920)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3f20), result)
            }
            mstore(
                add(transcript, 0x3f40),
                mulmod(
                    mload(add(transcript, 0x3f20)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f60),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3f40))),
                    mload(add(transcript, 0x3840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3f80),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3840)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x3fa0),
                addmod(
                    mload(add(transcript, 0x3f00)),
                    mload(add(transcript, 0x3f60)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x960)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x3fc0), result)
            }
            mstore(
                add(transcript, 0x3fe0),
                mulmod(
                    mload(add(transcript, 0x3fc0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4000),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x3fe0))),
                    mload(add(transcript, 0x3860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4020),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4040),
                addmod(
                    mload(add(transcript, 0x3fa0)),
                    mload(add(transcript, 0x4000)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x980)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x4060), result)
            }
            mstore(
                add(transcript, 0x4080),
                mulmod(
                    mload(add(transcript, 0x4060)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x40a0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4080))),
                    mload(add(transcript, 0x3880)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x40c0),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3880)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x40e0),
                addmod(
                    mload(add(transcript, 0x4040)),
                    mload(add(transcript, 0x40a0)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x9a0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x4100), result)
            }
            mstore(
                add(transcript, 0x4120),
                mulmod(
                    mload(add(transcript, 0x4100)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4140),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4120))),
                    mload(add(transcript, 0x38a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4160),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x38a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4180),
                addmod(
                    mload(add(transcript, 0x40e0)),
                    mload(add(transcript, 0x4140)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x9c0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x41a0), result)
            }
            mstore(
                add(transcript, 0x41c0),
                mulmod(
                    mload(add(transcript, 0x41a0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x41e0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x41c0))),
                    mload(add(transcript, 0x38c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4200),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x38c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4220),
                addmod(
                    mload(add(transcript, 0x4180)),
                    mload(add(transcript, 0x41e0)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x9e0)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x4240), result)
            }
            mstore(
                add(transcript, 0x4260),
                mulmod(
                    mload(add(transcript, 0x4240)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4280),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4260))),
                    mload(add(transcript, 0x38e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x42a0),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x38e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x42c0),
                addmod(
                    mload(add(transcript, 0x4220)),
                    mload(add(transcript, 0x4280)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xa00)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x42e0), result)
            }
            mstore(
                add(transcript, 0x4300),
                mulmod(
                    mload(add(transcript, 0x42e0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4320),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4300))),
                    mload(add(transcript, 0x3900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4340),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3900)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4360),
                addmod(
                    mload(add(transcript, 0x42c0)),
                    mload(add(transcript, 0x4320)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4380),
                mulmod(
                    mload(add(transcript, 0x2de0)),
                    mload(add(transcript, 0x3500)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x43a0),
                mulmod(
                    mload(add(transcript, 0x2e00)),
                    mload(add(transcript, 0x3500)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x2e20)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x43c0), result)
            }
            mstore(
                add(transcript, 0x43e0),
                mulmod(
                    mload(add(transcript, 0x43c0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4400),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x43e0))),
                    mload(add(transcript, 0x3920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4420),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4440),
                mulmod(
                    mload(add(transcript, 0x4380)),
                    mload(add(transcript, 0x3920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4460),
                mulmod(
                    mload(add(transcript, 0x43a0)),
                    mload(add(transcript, 0x3920)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4480),
                addmod(
                    mload(add(transcript, 0x4360)),
                    mload(add(transcript, 0x4400)),
                    f_q
                )
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0x940)),
                    mload(add(transcript, 0x30e0)),
                    f_q
                )
                mstore(add(transcript, 0x44a0), result)
            }
            mstore(
                add(transcript, 0x44c0),
                mulmod(
                    mload(add(transcript, 0x44a0)),
                    mload(add(transcript, 0x3760)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x44e0),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x44c0))),
                    mload(add(transcript, 0x3940)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4500),
                mulmod(
                    mload(add(transcript, 0x3c00)),
                    mload(add(transcript, 0x3940)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4520),
                addmod(
                    mload(add(transcript, 0x4480)),
                    mload(add(transcript, 0x44e0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4540),
                mulmod(
                    mload(add(transcript, 0x4520)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4560),
                mulmod(
                    mload(add(transcript, 0x3c80)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4580),
                mulmod(
                    mload(add(transcript, 0x3d00)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x45a0),
                mulmod(
                    mload(add(transcript, 0x3da0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x45c0),
                mulmod(
                    mload(add(transcript, 0x3e40)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x45e0),
                mulmod(
                    mload(add(transcript, 0x3ee0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4600),
                mulmod(
                    mload(add(transcript, 0x3f80)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4620),
                mulmod(
                    mload(add(transcript, 0x4020)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4640),
                mulmod(
                    mload(add(transcript, 0x40c0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4660),
                mulmod(
                    mload(add(transcript, 0x4160)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4680),
                mulmod(
                    mload(add(transcript, 0x4200)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x46a0),
                mulmod(
                    mload(add(transcript, 0x42a0)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x46c0),
                mulmod(
                    mload(add(transcript, 0x4340)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x46e0),
                mulmod(
                    mload(add(transcript, 0x4420)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4700),
                mulmod(
                    mload(add(transcript, 0x4440)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4720),
                mulmod(
                    mload(add(transcript, 0x4460)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4740),
                mulmod(
                    mload(add(transcript, 0x4500)),
                    mload(add(transcript, 0xc40)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4760),
                addmod(
                    mload(add(transcript, 0x3ba0)),
                    mload(add(transcript, 0x4540)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4780),
                mulmod(1, mload(add(transcript, 0x3540)), f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xa20)),
                    mload(add(transcript, 0x3100)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xa40)),
                        mload(add(transcript, 0x3120)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xa60)),
                        mload(add(transcript, 0x3140)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x47a0), result)
            }
            mstore(
                add(transcript, 0x47c0),
                mulmod(
                    mload(add(transcript, 0x47a0)),
                    mload(add(transcript, 0x3780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x47e0),
                mulmod(sub(f_q, mload(add(transcript, 0x47c0))), 1, f_q)
            )
            mstore(
                add(transcript, 0x4800),
                mulmod(mload(add(transcript, 0x4780)), 1, f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xa80)),
                    mload(add(transcript, 0x3100)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xaa0)),
                        mload(add(transcript, 0x3120)),
                        f_q
                    ),
                    result,
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xac0)),
                        mload(add(transcript, 0x3140)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x4820), result)
            }
            mstore(
                add(transcript, 0x4840),
                mulmod(
                    mload(add(transcript, 0x4820)),
                    mload(add(transcript, 0x3780)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4860),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4840))),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4880),
                mulmod(
                    mload(add(transcript, 0x4780)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x48a0),
                addmod(
                    mload(add(transcript, 0x47e0)),
                    mload(add(transcript, 0x4860)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x48c0),
                mulmod(
                    mload(add(transcript, 0x48a0)),
                    mload(add(transcript, 0x3980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x48e0),
                mulmod(
                    mload(add(transcript, 0x4800)),
                    mload(add(transcript, 0x3980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4900),
                mulmod(
                    mload(add(transcript, 0x4880)),
                    mload(add(transcript, 0x3980)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4920),
                addmod(
                    mload(add(transcript, 0x4760)),
                    mload(add(transcript, 0x48c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4940),
                mulmod(1, mload(add(transcript, 0x3580)), f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xae0)),
                    mload(add(transcript, 0x3180)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xb00)),
                        mload(add(transcript, 0x31a0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x4960), result)
            }
            mstore(
                add(transcript, 0x4980),
                mulmod(
                    mload(add(transcript, 0x4960)),
                    mload(add(transcript, 0x37a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x49a0),
                mulmod(sub(f_q, mload(add(transcript, 0x4980))), 1, f_q)
            )
            mstore(
                add(transcript, 0x49c0),
                mulmod(mload(add(transcript, 0x4940)), 1, f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xb20)),
                    mload(add(transcript, 0x3180)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xb40)),
                        mload(add(transcript, 0x31a0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x49e0), result)
            }
            mstore(
                add(transcript, 0x4a00),
                mulmod(
                    mload(add(transcript, 0x49e0)),
                    mload(add(transcript, 0x37a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a20),
                mulmod(
                    sub(f_q, mload(add(transcript, 0x4a00))),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a40),
                mulmod(
                    mload(add(transcript, 0x4940)),
                    mload(add(transcript, 0xbe0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a60),
                addmod(
                    mload(add(transcript, 0x49a0)),
                    mload(add(transcript, 0x4a20)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4a80),
                mulmod(
                    mload(add(transcript, 0x4a60)),
                    mload(add(transcript, 0x39a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4aa0),
                mulmod(
                    mload(add(transcript, 0x49c0)),
                    mload(add(transcript, 0x39a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ac0),
                mulmod(
                    mload(add(transcript, 0x4a40)),
                    mload(add(transcript, 0x39a0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4ae0),
                addmod(
                    mload(add(transcript, 0x4920)),
                    mload(add(transcript, 0x4a80)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b00),
                mulmod(1, mload(add(transcript, 0x35c0)), f_q)
            )
            {
                let result := mulmod(
                    mload(add(transcript, 0xb60)),
                    mload(add(transcript, 0x31c0)),
                    f_q
                )
                result := addmod(
                    mulmod(
                        mload(add(transcript, 0xb80)),
                        mload(add(transcript, 0x31e0)),
                        f_q
                    ),
                    result,
                    f_q
                )
                mstore(add(transcript, 0x4b20), result)
            }
            mstore(
                add(transcript, 0x4b40),
                mulmod(
                    mload(add(transcript, 0x4b20)),
                    mload(add(transcript, 0x37c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4b60),
                mulmod(sub(f_q, mload(add(transcript, 0x4b40))), 1, f_q)
            )
            mstore(
                add(transcript, 0x4b80),
                mulmod(mload(add(transcript, 0x4b00)), 1, f_q)
            )
            mstore(
                add(transcript, 0x4ba0),
                mulmod(
                    mload(add(transcript, 0x4b60)),
                    mload(add(transcript, 0x39c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4bc0),
                mulmod(
                    mload(add(transcript, 0x4b80)),
                    mload(add(transcript, 0x39c0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4be0),
                addmod(
                    mload(add(transcript, 0x4ae0)),
                    mload(add(transcript, 0x4ba0)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x4c00),
                mulmod(1, mload(add(transcript, 0x30c0)), f_q)
            )
            mstore(
                add(transcript, 0x4c20),
                mulmod(1, mload(add(transcript, 0xce0)), f_q)
            )
            mstore(
                add(transcript, 0x4c40),
                0x0000000000000000000000000000000000000000000000000000000000000001
            )
            mstore(
                add(transcript, 0x4c60),
                0x0000000000000000000000000000000000000000000000000000000000000002
            )
            mstore(add(transcript, 0x4c80), mload(add(transcript, 0x4be0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x4c40),
                        0x60,
                        add(transcript, 0x4c40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4ca0), mload(add(transcript, 0x4c40)))
            mstore(add(transcript, 0x4cc0), mload(add(transcript, 0x4c60)))
            mstore(add(transcript, 0x4ce0), mload(add(transcript, 0x1c0)))
            mstore(add(transcript, 0x4d00), mload(add(transcript, 0x1e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x4ca0),
                        0x80,
                        add(transcript, 0x4ca0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4d20), mload(add(transcript, 0x200)))
            mstore(add(transcript, 0x4d40), mload(add(transcript, 0x220)))
            mstore(add(transcript, 0x4d60), mload(add(transcript, 0x3bc0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x4d20),
                        0x60,
                        add(transcript, 0x4d20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4d80), mload(add(transcript, 0x4ca0)))
            mstore(add(transcript, 0x4da0), mload(add(transcript, 0x4cc0)))
            mstore(add(transcript, 0x4dc0), mload(add(transcript, 0x4d20)))
            mstore(add(transcript, 0x4de0), mload(add(transcript, 0x4d40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x4d80),
                        0x80,
                        add(transcript, 0x4d80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4e00), mload(add(transcript, 0x240)))
            mstore(add(transcript, 0x4e20), mload(add(transcript, 0x260)))
            mstore(add(transcript, 0x4e40), mload(add(transcript, 0x3be0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x4e00),
                        0x60,
                        add(transcript, 0x4e00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4e60), mload(add(transcript, 0x4d80)))
            mstore(add(transcript, 0x4e80), mload(add(transcript, 0x4da0)))
            mstore(add(transcript, 0x4ea0), mload(add(transcript, 0x4e00)))
            mstore(add(transcript, 0x4ec0), mload(add(transcript, 0x4e20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x4e60),
                        0x80,
                        add(transcript, 0x4e60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4ee0), mload(add(transcript, 0x280)))
            mstore(add(transcript, 0x4f00), mload(add(transcript, 0x2a0)))
            mstore(add(transcript, 0x4f20), mload(add(transcript, 0x4560)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x4ee0),
                        0x60,
                        add(transcript, 0x4ee0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4f40), mload(add(transcript, 0x4e60)))
            mstore(add(transcript, 0x4f60), mload(add(transcript, 0x4e80)))
            mstore(add(transcript, 0x4f80), mload(add(transcript, 0x4ee0)))
            mstore(add(transcript, 0x4fa0), mload(add(transcript, 0x4f00)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x4f40),
                        0x80,
                        add(transcript, 0x4f40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x4fc0), mload(add(transcript, 0x360)))
            mstore(add(transcript, 0x4fe0), mload(add(transcript, 0x380)))
            mstore(add(transcript, 0x5000), mload(add(transcript, 0x4580)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x4fc0),
                        0x60,
                        add(transcript, 0x4fc0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5020), mload(add(transcript, 0x4f40)))
            mstore(add(transcript, 0x5040), mload(add(transcript, 0x4f60)))
            mstore(add(transcript, 0x5060), mload(add(transcript, 0x4fc0)))
            mstore(add(transcript, 0x5080), mload(add(transcript, 0x4fe0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5020),
                        0x80,
                        add(transcript, 0x5020),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x50a0),
                0x19d8cec6a52aa8030e75b4f04602f52fbe38e29fee5a082faf2e5e27db8f302b
            )
            mstore(
                add(transcript, 0x50c0),
                0x1648e9e5cfa66c83da444f77bcfd38578df09238ea795c068165286c8e70c68c
            )
            mstore(add(transcript, 0x50e0), mload(add(transcript, 0x45a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x50a0),
                        0x60,
                        add(transcript, 0x50a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5100), mload(add(transcript, 0x5020)))
            mstore(add(transcript, 0x5120), mload(add(transcript, 0x5040)))
            mstore(add(transcript, 0x5140), mload(add(transcript, 0x50a0)))
            mstore(add(transcript, 0x5160), mload(add(transcript, 0x50c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5100),
                        0x80,
                        add(transcript, 0x5100),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5180),
                0x09f25a9fd8407396ed36812862d704c0bb056b8d81ad5bf71794cc83dffddaf5
            )
            mstore(
                add(transcript, 0x51a0),
                0x115eff1b897f093a0749e25cd0486ea77ab4ffef2ff9188a7fdb4b45c1509a01
            )
            mstore(add(transcript, 0x51c0), mload(add(transcript, 0x45c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5180),
                        0x60,
                        add(transcript, 0x5180),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x51e0), mload(add(transcript, 0x5100)))
            mstore(add(transcript, 0x5200), mload(add(transcript, 0x5120)))
            mstore(add(transcript, 0x5220), mload(add(transcript, 0x5180)))
            mstore(add(transcript, 0x5240), mload(add(transcript, 0x51a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x51e0),
                        0x80,
                        add(transcript, 0x51e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5260),
                0x25ca9ede5eb8b0e566b5e3f1a9634475474b69b77c9945f4b6e67164a5b6402a
            )
            mstore(
                add(transcript, 0x5280),
                0x1c8303acb2264713a3422b0a955ab777b29a2de3d97675b0d11b157278d4f87b
            )
            mstore(add(transcript, 0x52a0), mload(add(transcript, 0x45e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5260),
                        0x60,
                        add(transcript, 0x5260),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x52c0), mload(add(transcript, 0x51e0)))
            mstore(add(transcript, 0x52e0), mload(add(transcript, 0x5200)))
            mstore(add(transcript, 0x5300), mload(add(transcript, 0x5260)))
            mstore(add(transcript, 0x5320), mload(add(transcript, 0x5280)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x52c0),
                        0x80,
                        add(transcript, 0x52c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5340),
                0x2d6a558c973ce3963a0b14d03fb17b2926812a19117c0d317ce66c530869e7fb
            )
            mstore(
                add(transcript, 0x5360),
                0x26f28f9319ec9cf8da8896ea9ba05f2da07e3b23f8e147c4f59cdd29565b8108
            )
            mstore(add(transcript, 0x5380), mload(add(transcript, 0x4600)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5340),
                        0x60,
                        add(transcript, 0x5340),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x53a0), mload(add(transcript, 0x52c0)))
            mstore(add(transcript, 0x53c0), mload(add(transcript, 0x52e0)))
            mstore(add(transcript, 0x53e0), mload(add(transcript, 0x5340)))
            mstore(add(transcript, 0x5400), mload(add(transcript, 0x5360)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x53a0),
                        0x80,
                        add(transcript, 0x53a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5420),
                0x2642d0056a8c34778f9e04916cbdc169c5b69519b5d810f4181c20217d04ee57
            )
            mstore(
                add(transcript, 0x5440),
                0x02199c743c7a20ff21deea9d961747e09562f9fd67bed984f59721bee90b004d
            )
            mstore(add(transcript, 0x5460), mload(add(transcript, 0x4620)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5420),
                        0x60,
                        add(transcript, 0x5420),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5480), mload(add(transcript, 0x53a0)))
            mstore(add(transcript, 0x54a0), mload(add(transcript, 0x53c0)))
            mstore(add(transcript, 0x54c0), mload(add(transcript, 0x5420)))
            mstore(add(transcript, 0x54e0), mload(add(transcript, 0x5440)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5480),
                        0x80,
                        add(transcript, 0x5480),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5500),
                0x17858efc68394b2ecf35db4998cc6f9f765704f20c7da79aef7352c23bf000c8
            )
            mstore(
                add(transcript, 0x5520),
                0x06e6d3e087bc5fbe0745501e8f1c544b215a676ec7bf49beecd2b066ce8481b0
            )
            mstore(add(transcript, 0x5540), mload(add(transcript, 0x4640)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5500),
                        0x60,
                        add(transcript, 0x5500),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5560), mload(add(transcript, 0x5480)))
            mstore(add(transcript, 0x5580), mload(add(transcript, 0x54a0)))
            mstore(add(transcript, 0x55a0), mload(add(transcript, 0x5500)))
            mstore(add(transcript, 0x55c0), mload(add(transcript, 0x5520)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5560),
                        0x80,
                        add(transcript, 0x5560),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x55e0),
                0x21ac7aed17a705fd0f4c33dd64430f9401c506641dfbbead83150075e934482d
            )
            mstore(
                add(transcript, 0x5600),
                0x15aee1e1c3ed9b8ae37dbe68da9bc78ca3da743fc9816eadc16fe614d0e33a82
            )
            mstore(add(transcript, 0x5620), mload(add(transcript, 0x4660)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x55e0),
                        0x60,
                        add(transcript, 0x55e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5640), mload(add(transcript, 0x5560)))
            mstore(add(transcript, 0x5660), mload(add(transcript, 0x5580)))
            mstore(add(transcript, 0x5680), mload(add(transcript, 0x55e0)))
            mstore(add(transcript, 0x56a0), mload(add(transcript, 0x5600)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5640),
                        0x80,
                        add(transcript, 0x5640),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x56c0),
                0x2b04ff64f6e61036b97abd167db7534427c7e2ed21495d9934c68d8920fe3551
            )
            mstore(
                add(transcript, 0x56e0),
                0x1cff56c2797f9d5177817b62660a96a0a76d127f650aaf439431854e64a521fa
            )
            mstore(add(transcript, 0x5700), mload(add(transcript, 0x4680)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x56c0),
                        0x60,
                        add(transcript, 0x56c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5720), mload(add(transcript, 0x5640)))
            mstore(add(transcript, 0x5740), mload(add(transcript, 0x5660)))
            mstore(add(transcript, 0x5760), mload(add(transcript, 0x56c0)))
            mstore(add(transcript, 0x5780), mload(add(transcript, 0x56e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5720),
                        0x80,
                        add(transcript, 0x5720),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x57a0),
                0x0b1a6b226104f79a9e14c317ec28dfdea6575c0ae76bf90a52df511d5c69e262
            )
            mstore(
                add(transcript, 0x57c0),
                0x0029b105974a78eea87070eabe235ed3439e350661e1142419106c0334adfcdd
            )
            mstore(add(transcript, 0x57e0), mload(add(transcript, 0x46a0)))
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
            mstore(add(transcript, 0x5800), mload(add(transcript, 0x5720)))
            mstore(add(transcript, 0x5820), mload(add(transcript, 0x5740)))
            mstore(add(transcript, 0x5840), mload(add(transcript, 0x57a0)))
            mstore(add(transcript, 0x5860), mload(add(transcript, 0x57c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5800),
                        0x80,
                        add(transcript, 0x5800),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(
                add(transcript, 0x5880),
                0x1fa941f9edafbcfb5a49d38b732805b58c7d72b3ba15128e1e5460f786630f8e
            )
            mstore(
                add(transcript, 0x58a0),
                0x032b5a3a9b1565ad51169b56bfbd0e6f9b6320bdce07a9fe8638b6210ca719e5
            )
            mstore(add(transcript, 0x58c0), mload(add(transcript, 0x46c0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5880),
                        0x60,
                        add(transcript, 0x5880),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x58e0), mload(add(transcript, 0x5800)))
            mstore(add(transcript, 0x5900), mload(add(transcript, 0x5820)))
            mstore(add(transcript, 0x5920), mload(add(transcript, 0x5880)))
            mstore(add(transcript, 0x5940), mload(add(transcript, 0x58a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x58e0),
                        0x80,
                        add(transcript, 0x58e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5960), mload(add(transcript, 0x600)))
            mstore(add(transcript, 0x5980), mload(add(transcript, 0x620)))
            mstore(add(transcript, 0x59a0), mload(add(transcript, 0x46e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5960),
                        0x60,
                        add(transcript, 0x5960),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x59c0), mload(add(transcript, 0x58e0)))
            mstore(add(transcript, 0x59e0), mload(add(transcript, 0x5900)))
            mstore(add(transcript, 0x5a00), mload(add(transcript, 0x5960)))
            mstore(add(transcript, 0x5a20), mload(add(transcript, 0x5980)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x59c0),
                        0x80,
                        add(transcript, 0x59c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5a40), mload(add(transcript, 0x640)))
            mstore(add(transcript, 0x5a60), mload(add(transcript, 0x660)))
            mstore(add(transcript, 0x5a80), mload(add(transcript, 0x4700)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5a40),
                        0x60,
                        add(transcript, 0x5a40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5aa0), mload(add(transcript, 0x59c0)))
            mstore(add(transcript, 0x5ac0), mload(add(transcript, 0x59e0)))
            mstore(add(transcript, 0x5ae0), mload(add(transcript, 0x5a40)))
            mstore(add(transcript, 0x5b00), mload(add(transcript, 0x5a60)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5aa0),
                        0x80,
                        add(transcript, 0x5aa0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5b20), mload(add(transcript, 0x680)))
            mstore(add(transcript, 0x5b40), mload(add(transcript, 0x6a0)))
            mstore(add(transcript, 0x5b60), mload(add(transcript, 0x4720)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5b20),
                        0x60,
                        add(transcript, 0x5b20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5b80), mload(add(transcript, 0x5aa0)))
            mstore(add(transcript, 0x5ba0), mload(add(transcript, 0x5ac0)))
            mstore(add(transcript, 0x5bc0), mload(add(transcript, 0x5b20)))
            mstore(add(transcript, 0x5be0), mload(add(transcript, 0x5b40)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5b80),
                        0x80,
                        add(transcript, 0x5b80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5c00), mload(add(transcript, 0x560)))
            mstore(add(transcript, 0x5c20), mload(add(transcript, 0x580)))
            mstore(add(transcript, 0x5c40), mload(add(transcript, 0x4740)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5c00),
                        0x60,
                        add(transcript, 0x5c00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5c60), mload(add(transcript, 0x5b80)))
            mstore(add(transcript, 0x5c80), mload(add(transcript, 0x5ba0)))
            mstore(add(transcript, 0x5ca0), mload(add(transcript, 0x5c00)))
            mstore(add(transcript, 0x5cc0), mload(add(transcript, 0x5c20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5c60),
                        0x80,
                        add(transcript, 0x5c60),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5ce0), mload(add(transcript, 0x460)))
            mstore(add(transcript, 0x5d00), mload(add(transcript, 0x480)))
            mstore(add(transcript, 0x5d20), mload(add(transcript, 0x48e0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5ce0),
                        0x60,
                        add(transcript, 0x5ce0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5d40), mload(add(transcript, 0x5c60)))
            mstore(add(transcript, 0x5d60), mload(add(transcript, 0x5c80)))
            mstore(add(transcript, 0x5d80), mload(add(transcript, 0x5ce0)))
            mstore(add(transcript, 0x5da0), mload(add(transcript, 0x5d00)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5d40),
                        0x80,
                        add(transcript, 0x5d40),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5dc0), mload(add(transcript, 0x4a0)))
            mstore(add(transcript, 0x5de0), mload(add(transcript, 0x4c0)))
            mstore(add(transcript, 0x5e00), mload(add(transcript, 0x4900)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5dc0),
                        0x60,
                        add(transcript, 0x5dc0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5e20), mload(add(transcript, 0x5d40)))
            mstore(add(transcript, 0x5e40), mload(add(transcript, 0x5d60)))
            mstore(add(transcript, 0x5e60), mload(add(transcript, 0x5dc0)))
            mstore(add(transcript, 0x5e80), mload(add(transcript, 0x5de0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5e20),
                        0x80,
                        add(transcript, 0x5e20),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5ea0), mload(add(transcript, 0x4e0)))
            mstore(add(transcript, 0x5ec0), mload(add(transcript, 0x500)))
            mstore(add(transcript, 0x5ee0), mload(add(transcript, 0x4aa0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5ea0),
                        0x60,
                        add(transcript, 0x5ea0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5f00), mload(add(transcript, 0x5e20)))
            mstore(add(transcript, 0x5f20), mload(add(transcript, 0x5e40)))
            mstore(add(transcript, 0x5f40), mload(add(transcript, 0x5ea0)))
            mstore(add(transcript, 0x5f60), mload(add(transcript, 0x5ec0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5f00),
                        0x80,
                        add(transcript, 0x5f00),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5f80), mload(add(transcript, 0x520)))
            mstore(add(transcript, 0x5fa0), mload(add(transcript, 0x540)))
            mstore(add(transcript, 0x5fc0), mload(add(transcript, 0x4ac0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x5f80),
                        0x60,
                        add(transcript, 0x5f80),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x5fe0), mload(add(transcript, 0x5f00)))
            mstore(add(transcript, 0x6000), mload(add(transcript, 0x5f20)))
            mstore(add(transcript, 0x6020), mload(add(transcript, 0x5f80)))
            mstore(add(transcript, 0x6040), mload(add(transcript, 0x5fa0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x5fe0),
                        0x80,
                        add(transcript, 0x5fe0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6060), mload(add(transcript, 0x320)))
            mstore(add(transcript, 0x6080), mload(add(transcript, 0x340)))
            mstore(add(transcript, 0x60a0), mload(add(transcript, 0x4bc0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6060),
                        0x60,
                        add(transcript, 0x6060),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x60c0), mload(add(transcript, 0x5fe0)))
            mstore(add(transcript, 0x60e0), mload(add(transcript, 0x6000)))
            mstore(add(transcript, 0x6100), mload(add(transcript, 0x6060)))
            mstore(add(transcript, 0x6120), mload(add(transcript, 0x6080)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x60c0),
                        0x80,
                        add(transcript, 0x60c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6140), mload(add(transcript, 0xc80)))
            mstore(add(transcript, 0x6160), mload(add(transcript, 0xca0)))
            mstore(
                add(transcript, 0x6180),
                sub(f_q, mload(add(transcript, 0x4c00)))
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6140),
                        0x60,
                        add(transcript, 0x6140),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x61a0), mload(add(transcript, 0x60c0)))
            mstore(add(transcript, 0x61c0), mload(add(transcript, 0x60e0)))
            mstore(add(transcript, 0x61e0), mload(add(transcript, 0x6140)))
            mstore(add(transcript, 0x6200), mload(add(transcript, 0x6160)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x61a0),
                        0x80,
                        add(transcript, 0x61a0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6220), mload(add(transcript, 0xd20)))
            mstore(add(transcript, 0x6240), mload(add(transcript, 0xd40)))
            mstore(add(transcript, 0x6260), mload(add(transcript, 0x4c20)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6220),
                        0x60,
                        add(transcript, 0x6220),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6280), mload(add(transcript, 0x61a0)))
            mstore(add(transcript, 0x62a0), mload(add(transcript, 0x61c0)))
            mstore(add(transcript, 0x62c0), mload(add(transcript, 0x6220)))
            mstore(add(transcript, 0x62e0), mload(add(transcript, 0x6240)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x6280),
                        0x80,
                        add(transcript, 0x6280),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6300), mload(add(transcript, 0x6280)))
            mstore(add(transcript, 0x6320), mload(add(transcript, 0x62a0)))
            mstore(add(transcript, 0x6340), mload(add(transcript, 0xd20)))
            mstore(add(transcript, 0x6360), mload(add(transcript, 0xd40)))
            mstore(add(transcript, 0x6380), mload(add(transcript, 0xd60)))
            mstore(add(transcript, 0x63a0), mload(add(transcript, 0xd80)))
            mstore(add(transcript, 0x63c0), mload(add(transcript, 0xda0)))
            mstore(add(transcript, 0x63e0), mload(add(transcript, 0xdc0)))
            mstore(
                add(transcript, 0x6400),
                keccak256(add(transcript, 0x6300), 256)
            )
            mstore(add(transcript, 0x6420), mod(mload(25600), f_q))
            mstore(
                add(transcript, 0x6440),
                mulmod(
                    mload(add(transcript, 0x6420)),
                    mload(add(transcript, 0x6420)),
                    f_q
                )
            )
            mstore(
                add(transcript, 0x6460),
                mulmod(1, mload(add(transcript, 0x6420)), f_q)
            )
            mstore(add(transcript, 0x6480), mload(add(transcript, 0x6380)))
            mstore(add(transcript, 0x64a0), mload(add(transcript, 0x63a0)))
            mstore(add(transcript, 0x64c0), mload(add(transcript, 0x6460)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6480),
                        0x60,
                        add(transcript, 0x6480),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x64e0), mload(add(transcript, 0x6300)))
            mstore(add(transcript, 0x6500), mload(add(transcript, 0x6320)))
            mstore(add(transcript, 0x6520), mload(add(transcript, 0x6480)))
            mstore(add(transcript, 0x6540), mload(add(transcript, 0x64a0)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x64e0),
                        0x80,
                        add(transcript, 0x64e0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6560), mload(add(transcript, 0x63c0)))
            mstore(add(transcript, 0x6580), mload(add(transcript, 0x63e0)))
            mstore(add(transcript, 0x65a0), mload(add(transcript, 0x6460)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x7,
                        add(transcript, 0x6560),
                        0x60,
                        add(transcript, 0x6560),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x65c0), mload(add(transcript, 0x6340)))
            mstore(add(transcript, 0x65e0), mload(add(transcript, 0x6360)))
            mstore(add(transcript, 0x6600), mload(add(transcript, 0x6560)))
            mstore(add(transcript, 0x6620), mload(add(transcript, 0x6580)))
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x6,
                        add(transcript, 0x65c0),
                        0x80,
                        add(transcript, 0x65c0),
                        0x40
                    ),
                    1
                ),
                success
            )
            mstore(add(transcript, 0x6640), mload(add(transcript, 0x64e0)))
            mstore(add(transcript, 0x6660), mload(add(transcript, 0x6500)))
            mstore(
                add(transcript, 0x6680),
                0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2
            )
            mstore(
                add(transcript, 0x66a0),
                0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed
            )
            mstore(
                add(transcript, 0x66c0),
                0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b
            )
            mstore(
                add(transcript, 0x66e0),
                0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            )
            mstore(add(transcript, 0x6700), mload(add(transcript, 0x65c0)))
            mstore(add(transcript, 0x6720), mload(add(transcript, 0x65e0)))
            mstore(
                add(transcript, 0x6740),
                0x142614fff1204eb0a85a8605fd68646fecebd7e715f3471ccca7172d7dd0ed9f
            )
            mstore(
                add(transcript, 0x6760),
                0x223ca68fe3d7b9ebcc212b8986ad04b4f389fa0136c5b2a97697db22541e7519
            )
            mstore(
                add(transcript, 0x6780),
                0x1ea68c775c296761e88c1cdd50665b183046a306382decb73fa219f3360cc9d3
            )
            mstore(
                add(transcript, 0x67a0),
                0x133fd9d884ebbb50ba3135509bbe4fa21be0219afbf4773caa0cc0d2c19bc4d6
            )
            success := and(
                eq(
                    staticcall(
                        gas(),
                        0x8,
                        add(transcript, 0x6640),
                        0x180,
                        add(transcript, 0x6640),
                        0x20
                    ),
                    1
                ),
                success
            )
            success := and(eq(mload(add(transcript, 0x6640)), 1), success)
        }
        return success;
    }
}
