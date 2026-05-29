{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01075') }},
        {{ ref('model_01432') }},
        {{ ref('model_01243') }}
)
select id, 'model_01700' as name from sources
