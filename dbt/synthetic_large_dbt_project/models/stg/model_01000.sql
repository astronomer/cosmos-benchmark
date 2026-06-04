{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00234') }},
        {{ ref('model_00493') }}
)
select id, 'model_01000' as name from sources
