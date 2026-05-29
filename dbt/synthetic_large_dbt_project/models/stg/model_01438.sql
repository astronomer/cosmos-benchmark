{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00241') }},
        {{ ref('model_00433') }},
        {{ ref('model_00223') }}
)
select id, 'model_01438' as name from sources
