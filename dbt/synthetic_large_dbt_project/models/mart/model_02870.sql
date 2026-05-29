{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02198') }},
        {{ ref('model_02021') }},
        {{ ref('model_01744') }}
)
select id, 'model_02870' as name from sources
