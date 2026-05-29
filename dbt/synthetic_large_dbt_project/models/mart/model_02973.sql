{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01988') }},
        {{ ref('model_01851') }},
        {{ ref('model_01527') }}
)
select id, 'model_02973' as name from sources
