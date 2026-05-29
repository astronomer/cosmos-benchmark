{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00280') }},
        {{ ref('model_00155') }},
        {{ ref('model_00192') }}
)
select id, 'model_01147' as name from sources
