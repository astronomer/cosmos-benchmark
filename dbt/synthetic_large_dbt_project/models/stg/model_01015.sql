{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00292') }},
        {{ ref('model_00199') }},
        {{ ref('model_00034') }}
)
select id, 'model_01015' as name from sources
