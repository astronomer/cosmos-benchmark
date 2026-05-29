{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00480') }},
        {{ ref('model_00587') }},
        {{ ref('model_00339') }}
)
select id, 'model_01243' as name from sources
