{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00223') }},
        {{ ref('model_00115') }},
        {{ ref('model_00241') }}
)
select id, 'model_01081' as name from sources
