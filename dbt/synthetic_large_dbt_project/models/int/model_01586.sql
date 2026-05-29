{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01075') }},
        {{ ref('model_01448') }},
        {{ ref('model_01100') }}
)
select id, 'model_01586' as name from sources
