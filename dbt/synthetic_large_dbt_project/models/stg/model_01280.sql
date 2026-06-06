{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00658') }},
        {{ ref('model_00315') }},
        {{ ref('model_00511') }}
)
select id, 'model_01280' as name from sources
