{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00290') }},
        {{ ref('model_00426') }},
        {{ ref('model_00710') }}
)
select id, 'model_01293' as name from sources
