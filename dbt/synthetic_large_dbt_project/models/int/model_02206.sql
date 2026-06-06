{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01090') }},
        {{ ref('model_00897') }}
)
select id, 'model_02206' as name from sources
