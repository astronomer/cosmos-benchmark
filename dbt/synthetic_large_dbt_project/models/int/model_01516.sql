{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01366') }},
        {{ ref('model_01482') }}
)
select id, 'model_01516' as name from sources
